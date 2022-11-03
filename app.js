const { Environment } = require("./symbols/enviroment.js");
const {consola} = require("./patron_singleton/singleton.js");
var fs = require("fs");
var gramatica = require("./prueba.js");
const express = require('express');
const morgan = require('morgan');
const { publicDecrypt } = require("crypto");
const path = require('path');
const req = require("express/lib/request");
const res = require("express/lib/response");
const app = express();

//PARA ENTENDER ESTA MAMADA HAY QUE VER AQUEL VIDEO DE YOUTUBE QEU ESTABAMOS VIENDO EN AQUEL ENTONCES

app.use(morgan('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))



app.set('port',process.env.PORT || 8080)
app.get('/submit',(req,res)=>{


})
//static
app.use(express.static(path.join(__dirname,'/public')));


var texto = "";
app.listen(app.get('port'),() =>{
 
  console.log(`server on port ${app.get('port')}`)
 
})
function mapToObj(map){
  const obj = {}
  for (let [k,v] of map)
    obj[k] = v
  return obj
}
var entri = "";
app.post('/p', function (req, res) {
  console.log(req.body);
  res.send('datos recibidos')
})

app.get('/p', function (req, res) {
  var env_padre = new Environment(null);
  fs.readFile("./entrada.txt", (err, data) => {
    if (err) throw err;
   const ast =  gramatica.parse(data.toString());
   for (const elemento  of ast) {
    try {
        
        //preguntar si ese elemtno es de clase metodo o funciones
        
            elemento.executar(env_padre)
        
    } catch (error) {
        //console.log(error);
        
        
    }
}

console.log(env_padre.tablaSimbolos)
var j = "";
var myjson = {}
myjson.myMap = mapToObj(env_padre.tablaSimbolos);
j = env_padre.tablaSimbolos;
  console.log(myjson);
  //AQUI VA EL MYJSON
    res.json({ myjson  });
    res.toString(consola.cons)
  
    console.log("ACA EMPIEZA LA CONSOLA]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] ")
console.log(consola.cons)
    
  
  });
  
});