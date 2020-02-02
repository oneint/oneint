const { environment } = require('@rails/webpacker')
const webpack = require("webpack")

module.exports = environment

environment.plugins.append("Provide", new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default'],
}))
