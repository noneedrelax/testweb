module.exports = {
  plugins: [
    require('postcss-easy-import')({prefix: '_'}), // keep this first
    require('autoprefixer')({
        browsers: ['last 5 versions',  'Firefox > 19', 'ie >= 9', 'Opera >= 12.1', 'Safari >= 8', 'iOS >= 7', 'Android >=4'],
    }) // so imports are auto-prefixed too
  ]
};

