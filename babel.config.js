const presets = [
    [
        "@babel/env",
        {
            "targets": "> 0.25%, not dead",
            /*targets: {
                edge: "12",
                firefox: "40",
                chrome: "30",
                safari: "8",
                "ie": "11",
            },*/
            //forceAllTransforms: true,
            useBuiltIns: "usage",
        },
    ],
];

module.exports = { presets };
