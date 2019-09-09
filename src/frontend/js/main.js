import '../css/sass/styles.scss';
import $ from 'jquery';

const ERRORS = {
    2: 'Invalid credentials',
    3: 'Captcha required',
    900: 'Please enter a new Password',
    901: 'Please confirm your new Password',
    902: 'Please match your New Password and Confirmation',
    903: 'Please make your New Password different from your Old Password',
    999: 'Internal error',
};

const SMAUTHREASON = {
    0: {// Reason none
        label: 'Login Required',
        descr: 'Invalid credentials.',
        showUserField: true,
        showPasswordField: true,
    },

    1: {// Password must change
        label: 'Please change your password',
        descr: 'Please change your current password before continuing.',
        showUserField: true,
        showPasswordField: true,
    },

    4: {// Session Expired
        label: 'Session Expired',
        descr: 'Your session has expired. Please enter your username and passcode.',
        showUserField: true,
        showPasswordField: true,
    },

    5: {// AuthLevelTooLow
        label: 'Login Required',
        descr: 'A higher authentication level is needed. Please enter your username and passcode.',
        showUserField: true,
        showPasswordField: true,
    },

    7: {//Account disabled
        label: '',
        descr: "You cannot access your account at this time.\nPlease contact your Security Administrator or Help Desk.",
    },

    13: {// Invalid new password
        label: 'Invalid new password',
        descr: 'New password is invalid, please change it.',
        showPasswordField: true,
        showNewPasswordField: true,
    },

    14: {// Failed to change password
        label: 'Failed to change password',
        descr: 'Failed to change password.',
        showPasswordField: true,
        showNewPasswordField: true,
    },

    18: {// Optional password change
        label: 'Change Password',
        descr: 'Please change your current password before continuing.',
        showPasswordField: true,
        showNewPasswordField: true,
    },

    19: {// Account locked due to password expired
        label: 'Password Expired',
        descr: "You cannot access your account because your password has expired.\nPlease contact your Security Administrator or Help Desk.",
    },

    20: {// Password change immediately
        label: 'Change Password',
        descr: 'Please change your current password before continuing.',
        showPasswordField: true,
        showNewPasswordField: true,
    },

    21: {// Password change failed
        label: 'Change Password',
        descr: "Your password change request was not processed correctly.\nPlease try again.",
        showPasswordField: true,
        showNewPasswordField: true,
    },

    22: {// Bad Password
        label: 'Change Password',
        descr: "Your password change was not accepted.\n$$SMPWUSRMSG$$\nPlease try again.",
        showPasswordField: true,
        showNewPasswordField: true,
    },

    23: {// Password Change Accepted
        label: 'Password Changed Successfully',
        descr: "Your new password has been set.\nUse this new password the next time you log into your account.",
    },

    24: {// Account disabled due to excess login attempts
        label: 'Account Locked',
        descr: "You cannot access your account because you have exceeded the limit of login attempts.\nPlease contact your Security Administrator or Help Desk.",
    },

    25: {// Account disabled due to inactivity
        label: 'Account Disabled',
        descr: "Your account has been disabled due to inactivity.\nPlease contact your Security Administrator or Help Desk.",
    },
};

export class LoginForm {
    constructor(params = {}) {
        this.isFormSubmitted = false;
        this.isDebug = false;
        this.params = {
            // Default params
            gwBaseUrl: 'https://www.idfconnect.net/ssorest3',
            loginSuccess: null,
            loginForm: 'loginForm',
            debug: false,
        };
        this.params = $.extend({}, this.params, params);
        this.formObj = $(document.forms[this.params.loginForm]);
    }

    init() {
        let form = this.formObj;
        ['username', 'password', 'newpassword', 'newpassword2'].forEach(v => {
            $(this.getFormElement(v)).bind('blur', e => this.onInputBlur(e.currentTarget)).bind('focus', e => this.onInputFocus(e.currentTarget));
        });

        form
            .bind("submit", e => {
                let form = event.currentTarget;
                try {
                    if (this.checkForm(form)) {
                        this.postForm(form, {
                            url: this.params.gwBaseUrl + '/service/public/',
                        });
                    }
                } catch (e) {
                    this.logError('Error:', e);
                }

                return false;
            })
        ;

        setTimeout(() => {
            // Webkit autofill workaround
            try {
                if (!$('#username:-webkit-autofill').length) {
                    this.onInputBlur(this.getFormElement('username'));
                }
                if (!$('#password:-webkit-autofill').length) {
                    this.onInputBlur(this.getFormElement('password'));
                    this.onInputBlur(this.getFormElement('newpassword'));
                    this.onInputBlur(this.getFormElement('newpassword2'));
                }
            } catch(e) {
                // Not webkit
                $(this.getFormElements()).each((i, v) => {
                    if (v.type == 'text' || v.type == 'password') {
                        this.onInputBlur(v);
                    }
                });
            }
        }, 25);
    }

    logDebug() {
        if (! this.params.debug) {
            return;
        }

        this.log.apply(this, ['debug'].concat(arguments));
    }

    logError() {
        this.log.apply(this, ['error'].concat(arguments));
    }

    log(level = 'debug', ...args) {
        if (! console) {
            return;
        }

        let logMethod = console[level] ? console[level] : console.log;
        logMethod.apply(null, ...args);
    }

    getFormElements() {
        return document.forms[this.params.loginForm].elements;
    }

    getFormElement(el) {
        return this.getFormElements()[el];
    }

    focusFormElement(el) {
        document.forms[this.params.loginForm].elements[el].focus();
    }

    checkForm(form, params = {}) {
        let formData = this.getFormData(form);
        if (formData.formType == 'change') {
            if (this.isValueEmpty(formData.newpassword)) {
                this.setError(900);
                this.focusFormElement('newpassword');
                return false;
            }
            if (this.isValueEmpty(formData.newpassword2)) {
                this.setError(901);
                this.focusFormElement('newpassword2');
                return false;
            }
            if (formData.newpassword != formData.newpassword2) {
                this.setError(902);
                this.focusFormElement('newpassword2');
                return false;
            }
            if (formData.password == formData.newpassword) {
                this.setError(903);
                this.focusFormElement('newpassword');
                return false;
            }
        }

        return true;
    }

    isValueEmpty(val) {
        return (val == undefined || val.length == 0);
    }

    postForm(form, params = {}) {
        if (this.isFormSubmitted) {
            this.logDebug('Form is submitted already');
            return false;
        }

        let formData = this.getFormData(form);
        let data;
        if (formData.formType == 'login') {
            data = {
                username: formData.username,
                password: formData.password,
            };
        } else if (formData.formType == 'change') {
            data = {
                username: formData.username,
                oldpassword: formData.password,
                newpassword: formData.newpassword,
                dologin: true,
            };
        }
        // Pass newcaptcha values
        Object.keys(formData).forEach(k => {
            if (k.startsWith('nucaptcha-')) {
                data[k] = formData[k];
            }
        });

        $(form).find('button').addClass('loading');
        this.isFormSubmitted = true;
        let url = params.url + (data.newpassword == null ? 'login' : 'changepwd');

        // Add TARGET param from URL
        let urlParams = this.getUrlParams();
        if (urlParams.TARGET) {
            data.TARGET = this.undoSiteMinderEncoding(urlParams.TARGET);
        }

        $.ajax({
            method: params.method || 'post',
            url: url,
            dataType: 'json',
            data: data,
            timeout: params.timeout || 15000,
            error: (r, status) => {
                this.logDebug('Error: ', r.status, status);
                this.setError(999);
            },
            success: (data) => {
                this.logDebug('ok', data);
                if (! data || data.returnCode == null) {
                    this.setError(999);
                    return;
                }

                if (data.returnCode == 1) {
                    if (this.params.loginSuccess) {
                        this.params.loginSuccess(data);
                    }

                    $('#statusCont').hide();

                    return;
                } else if (data.returnCode == 2) {
                    let reason = data.reason !== undefined && SMAUTHREASON[data.reason] ? SMAUTHREASON[data.reason] : null;
                    if (reason) {
                        this.setError(reason.descr.replace(/\n/g, '<br/>'), true);
                        if (reason.showNewPasswordField) {
                            this.changeFormType('change');
                        } else {
                            this.changeFormType('login');
                        }
                    } else {
                        this.logDebug('Unknown reason', data);
                        this.setError(999);
                    }

                    return;
                } else if (data.returnCode == 3 && data.scoreResults.parameters.requiredAction == 'Interdiction') {
                    $('#status').html(data.scoreResults.parameters.html);
                    let player = $('#nucaptcha-player');
                    player.addClass('form-control-floating');
                    player.children('label').addClass('floating-animate');
                    player.children('input[type="text"]')
                            .addClass('input')
                            .bind('blur', e => this.onInputBlur(e.currentTarget))
                            .bind('focus', e => this.onInputFocus(e.currentTarget));
                    $('#statusCont').show();

                    return;
                }

                this.setError('Unknown error code');
                this.logDebug(data);
            },
            complete: () => {
                $(form).find('button').removeClass('loading');
                this.isFormSubmitted = false;
            }
        });

        return false;
    }

    changeFormType(type) {
        this.logDebug('Change form type to', type);
        let formType = this.getFormElement('formType');
        if (formType.value != type) {
            formType.value = type;
            if (type == 'login') {
                $('.form-row-newpassword').addClass('hidden');
                $('.form-row-newpassword2').addClass('hidden');
            } else if (type == 'change') {
                $('.form-row-newpassword').val('').removeClass('hidden');
                $('.form-row-newpassword2').val('').removeClass('hidden');
            }
        }
    }

    getFormData(form) {
        let formData = {};

        for (var i = 0; i < form.elements.length; i++) {
            let e = form.elements[i];
            if (['text', 'password', 'hidden'].indexOf(e.type) === -1) {
                continue;
            }
            formData[form.elements[i].name] = form.elements[i].value;
        }

        return formData;
    }

    onInputFocus(obj) {
        $(obj).siblings('label').addClass('floating-initial');
    }

    onInputBlur(obj) {
        if (! $(obj).val().length) {
            $(obj).siblings('label').removeClass('floating-initial');
        }
    }

    undoSiteMinderEncoding(str) {
        return str.replace(/^(-SM-|\$SM\$)/, '');
    }

    setError(str, isHtml = false) {
        var msg = typeof str === 'number' ? ERRORS[str] : str;
        if (isHtml) {
            $('#status').html($('<div class="error text"></div>').html(msg));
        } else {
            $('#status').html($('<div class="error text"></div>').text(msg));
        }
        $('#statusCont').show();
    }

    getUrlParams(paramName = null, search = null) {
        if (search == null) {
            search = this.getSearchString();
        }

        if (search) {
            const params = {};
            search.split('&').filter(p => p.length > 0).forEach(p => {
                const [key, value] = p.split('=');
                params[key] = value;
                params[key] = decodeURIComponent(value).replace('+', ' ');
            });
            if (paramName) {
                return params[paramName] || null;
            }
            return params;
        }

        return {};
    }

    getSearchSource() {
        return (this.isHtml5History() ? location.href : location.hash);
    }

    isHtml5History() {
        return (typeof history.pushState === 'function' && location.protocol !== 'file:');
    }

    getSearchString() {
        let search = '';
        let a = this.getSearchSource().split('?');
        if (a.length > 1) {
            search = a[1];
        }

        return search;
    }
}
