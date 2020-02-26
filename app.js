const express = require('express');

var app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.json({message: 'OK'})
})

app.listen(port, ()=> {
    console.log(`App listening on port ${port}`);
})