const path = require('path');

module.exports = {
  entry: './src/index.ts',
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: 'ts-loader',
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: [ '.ts', '.js' ],
  },
  optimization: {
    minimize: true
  },
  output: {
    filename: 'beagle.js',
    path: path.resolve(__dirname, '../beagle/assets/js'),
  },
};
