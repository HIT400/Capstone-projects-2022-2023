const proxy = require('http-proxy-middleware');

module.exports = function(App) {
  App.use(
    proxy(`/${i + 1}.json`, { 
        target: 'http://bafybeian6nvias4fgdipgacvjvhaoqb75hahjsivt3x2kb35fzkvx5l75q.ipfs.localhost:8080',
        secure: false,
        changeOrigin:true 
    
    
    }));
}