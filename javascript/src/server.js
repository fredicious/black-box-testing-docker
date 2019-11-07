const http = require('http');

const hostname = '0.0.0.0';
const port = 8080;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  if (req.url ==='/fruits') {
    res.setHeader('Content-Type', 'application/json');
    http.get('http://upstream/fruits', (response) => {
      let data = '';
      response.on('data', (chunk) => {
        data += chunk;
      });
      response.on('end', () => {
        res.end(data);
      });
    }).on("error", (err) => {
      console.log("Error: " + err.message);
    });
    return;
  }
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World\n');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});