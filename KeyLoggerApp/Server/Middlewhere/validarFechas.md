# BR: DEBE SELECCIONAR Y MARCAR COMO CHECK TODOS LOS ARCHIVOS CON FECHA DE MODIFICACIÓN POSTERIOR E IGUAL A LA FECHA PIVOTE 23/06/2024 QUE TIENE EL FORMATO dd/mm/aaaa

Este es el pseudocódigo.

## Pseudocódigo

```plaintext
FechaPivote <- 23/06/2024
ArchivosRecuperados <- [*] // Esto simula un arreglo de varias fechas

Inicio
	Para cada Archivo de la lista ArchivosRecuperados

		Seleccionar Archivo
		Obtener Fecha

		arrFechaPartes[] <- DividirFecha(Fecha)
		strDias <- arrFechaPartes['dias']
		strMes <- arrFechaPartes['mes']
		strAño <- arrFechaPartes['año']

		// Revisar que año corresponde a la fecha actual según BR
		BoolRevisionAño <- analizarAño(strAño)
	
		Si BoolRevisionAño es VERDADERO ENTONCES
			
			strMesPivote <- obtenerMesPivote(FechaPivote)
			boolDescargarArchivo <- calcularDisponibilidadDato(strMes, strMesPivote)
			
			SI boolDescargarArchivo es VERDADERO ENTONCES
				
				Marcar archivo para ser descargado
			
			SINO ENTONCES
			
				Continuar con la siguiente iteración

		SINO ENTONCES

			Continuar con la siguiente iteración

FIN


Public arr DividirFecha (Fecha) {

}

Public Boolean analizarAño (año) {


}

Public String PublicobtenerMesPivote(FechaPivote) {


}


Public Boolean calcularDisponibilidadDato(strDias, strMes, strMesPivote)  {



}