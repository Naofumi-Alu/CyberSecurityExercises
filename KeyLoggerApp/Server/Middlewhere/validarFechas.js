//Regla de negocio:  DEBE SELECCIONAR Y MARCAR COMO CHECK TODOS LOS ARCHIVOS CON FECHA DE MODIFICACIÓN POSTERIOR E IGUAL A LA FECHA PIVOTE 23/06/2024 QUE TIENE EL FORMATO dd/mm/aaaa
let fechasArreglo = new Array();
fechasArreglo = [
    '31/12/1979 07:00 p. m.',
    '31/12/1979 07:00 p. m.',
    '31/12/1979 07:00 p. m.',
    '31/12/1979 07:00 p. m.',
    '31/12/1979 07:00 p. m.',
    '17/06/2024 03:51 p. m.',
    '17/06/2024 08:40 p. m.',
    '17/06/2024 07:14 p. m.',
    '17/06/2024 08:01 p. m.',
    '17/06/2024 08:27 p. m.',
    '17/06/2024 08:01 p. m.',
    '07/06/2024 05:14 p. m.',
    '07/06/2024 05:14 p. m.',
    '07/06/2024 05:14 p. m.',
    '07/06/2024 05:14 p. m.',
    '02/07/2024 07:35 p. m.',
    '07/06/2024 05:14 p. m.',
    '07/06/2024 05:14 p. m.',
    '08/05/2024 04:40 p. m.',
    '02/07/2024 07:35 p. m.',
    '07/06/2024 05:12 p. m.',
    '07/06/2024 05:13 p. m.',
    '02/07/2024 07:35 p. m.',
    '07/06/2024 05:13 p. m.',
    '07/06/2024 05:13 p. m.',
    '08/05/2024 04:41 p. m.',
    '07/06/2024 05:14 p. m.',
    '02/07/2024 07:35 p. m.',
    '07/06/2024 05:14 p. m.'
];


function DefineItemsToSelect (fechasArreglo) {

    const fechaPivot = new String('23/06/2024 00:00 p. m.');
    
    let boolDescargarArchivo = false;
    let BoolRevisionAño = false; 

    let fechasArchivosDisponibles = new Array();

    fechasArreglo.forEach(fecha => {
        console.log("Archivo en a lista con fecha de reación " + fecha + " a revisar");
        // Esta es la fecha obtenida
        console.log(fecha);

        let arrFechasPartes = new Array();
        arrFechasPartes = DividirFecha(fecha);
        let strDias = arrFechasPartes[0];
        let strMes = arrFechasPartes[1];
        let strAño = arrFechasPartes[2];

        //Revisar que el año corresponde a la fecha actual segpun Regla de negocio
		
        BoolRevisionAño = analizarAño(strAño)


        if (BoolRevisionAño == true){
            let strMesPivote = obtenerMesPivote(fechaPivot);
            let strDiaPivote = obtenerDiaPivote(fechaPivot);
            boolDescargarArchivo = calcularDisponibilidadDato(strDias, strMes, strDiaPivote, strMesPivote);

            if (boolDescargarArchivo == true){
                console.log("Seleccionar archivo con fecha de creación: " + fecha.toString("dd/MM/yyyy hh:mm tt"));
                fechasArchivosDisponibles = fechasArchivosDisponibles.concat(fecha);
            }else{
                console.log("Continuar con la siguiente iteración");
            }
        } else {
            console.log("Continuar con la siguiente iteración");
        }


        
        
    });
    return fechasArchivosDisponibles;
}


function DividirFecha(fecha){
    let strFechaPartes = fecha.toString();
    strFechaPartes = strFechaPartes.split("/");

    return strFechaPartes;
}

function analizarAño (strAño) {
    let boolAño = false;
    let añoActualDate = new Date().getFullYear();
    strAño = strAño.split(" ")[0];
    let añoActual = añoActualDate.toString();
    if (strAño == añoActual){
        boolAño = true;
    }else{
        boolAño = false;
    }

    return boolAño;

}

function obtenerMesPivote(FechaPivote) {
    let strFechaPivote = FechaPivote.toString("dd/MM/yyyy hh:mm tt");

    let mesPivote = strFechaPivote.split("/")[1];

    return mesPivote;
}

function obtenerDiaPivote(FechaPivote) {
    let strFechaPivote = FechaPivote.toString("dd/MM/yyyy hh:mm tt");

    let diaPivote = strFechaPivote.split("/")[0];

    return diaPivote;
}

function calcularDisponibilidadDato(strDias, strMes, strDiaPivote, strMesPivote)  {

    console.log("Día: " + strDias);
    console.log("Mes: " + strMes);
    console.log("Día Pivote: " + strDiaPivote);
    console.log("Mes Pivote: " + strMesPivote);


    let boolDescargarArchivo = false;
    
    // validar si es un dia mayor siempre que los meses sean iguales
    if (strMes == strMesPivote && strDias >= strDiaPivote){
        boolDescargarArchivo = true;
        return boolDescargarArchivo;
    }
    if (strMes > strMesPivote){
        boolDescargarArchivo = true;
        return boolDescargarArchivo;
    }
}

export default function mainDefineItemsToSelect() {
    let fechasArchivosDisponibles = new Array();
    return fechasArchivosDisponibles = DefineItemsToSelect(fechasArreglo);
}