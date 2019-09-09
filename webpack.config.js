const path = require('path');
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");

const devMode = process.env.NODE_ENV !== 'production';
const SRC_BASE_DIR = './src/frontend';
const OUTPUT_BASE_DIR = './src/main/webapp/dist';

module.exports = {
    //mode: 'production',
    mode: 'development',
    entry: [SRC_BASE_DIR + '/js/main.js'],
    output: {
        filename: 'main.js',
        path: path.resolve(__dirname, OUTPUT_BASE_DIR),
        library: 'LoginLib',
    },
    externals: {
        jquery: 'jQuery'
    },

    optimization: {
        minimizer: [
            new UglifyJsPlugin({
                cache: true,
                parallel: true,
                //sourceMap: true // set to true if you want JS source maps
            }),
            new OptimizeCSSAssetsPlugin({}),
        ],
        splitChunks: {
            cacheGroups: {
                styles: {
                    name: 'styles',
                    test: /\.css$/,
                    chunks: 'all',
                    enforce: true
                }
            }
        },
    },

    plugins: [
        new MiniCssExtractPlugin({
            // Options similar to the same options in webpackOptions.output
            // both options are optional
            //filename: devMode ? '[name].css' : '[name].[hash].css',
            //chunkFilename: devMode ? '[id].css' : '[id].[hash].css',
            filename: '[name].css',
            chunkFilename: '[id].css',
        }),
        /*new CopyWebpackPlugin([
            { flatten: true, from: 'src/frontend/images/staples.svg', to: 'images/' }
        ]),*/
    ],

    module: {
        rules: [
            {
                test: /\.(sa|sc|c)ss$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    'postcss-loader',
                    'sass-loader',
                ],
            },
            {
                test: /\.(js|jsx)$/,
                exclude: /node_modules/,
                use: ['babel-loader']
            },
            {
                test: /\.(svg|png|jpg|gif)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: '[name].[ext]',
                            outputPath: 'images/'
                        }
                    }
                ]
            },
        ],
    },
};
