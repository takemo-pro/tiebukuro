const { environment } = require('@rails/webpacker')


const path = require('path')
const { link } = require('fs')

//sass-loader
const sassLoaders = environment.loaders.get('sass')
const sassLoaderConfig = sassLoaders.use.filter(config => config.loader === 'sass-loader')[0]

Object.assign(sassLoaderConfig.options,{
  data:"@import 'global-imports.scss';",
  includePaths:[path.resolve(__dirname,'../../../app/javascript/src/')]
})

module.exports = environment