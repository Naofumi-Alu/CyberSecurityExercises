import express from 'express';
import path from 'path';
import morgan from 'morgan';
import { env } from 'process';
import { fileURLToPath } from 'url';
import mainDefineItemsToSelect from './validarFechas.js';


//settings
const app = express();
const PORT = env.PORT || 3000;
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.set('port', PORT);


//Middlewares
app.use(morgan('dev'));
let fechasArchivosDisponibles = mainDefineItemsToSelect();
console.log(fechasArchivosDisponibles);

app.listen(PORT, () => {
    console.log(`Server on port ${PORT}`);
});