class Filosofo {
  const nombre
  //var edad
  var dias 
  const actividades = []
  const honorificos = []  // conjunto de títulos que describen perfectamente la esencia del filósofo

  var nivelDeIluminacion = 0

  method nivelDeIluminacion() = nivelDeIluminacion
  
  method disminuirNivelDeIluminacion(cantidad) {
    nivelDeIluminacion -= cantidad
  }

  method aumentarNivelDeIluminacion(cantidad) {
    nivelDeIluminacion += cantidad
  }
  
  //method edad() = edad

  method dias() = dias
  method rejuvenecer(cantidad) { dias -= cantidad}
  method envejecer(cantidad) { dias += cantidad}
  method edad() = dias.div(365)
  method esElCumpleanito() = dias % 365 == 0  // los dias es divisible por 365

  method agregarHonorifico(honorifico) {
    honorificos.add(honorifico)
  }

  method tieneHonorifico(honorifico) = honorificos.contains(honorifico)

  // 1) Pedirle a un filosofo que se presente...
  method presentarse() = nombre + self.honorificosSeparadosPorComa()
  method honorificosSeparadosPorComa() = honorificos.join(",") 

  // 2) Saber si un filosofo esta en lo correcto (Esto se cumple si su nivel de iluminación es mayor a 1000.)
  method estaEnLoCorrecto() = nivelDeIluminacion > 1000

  // Actividades que realiza el filosofo:

  method hacerActividad(actividad){   // ACTIVIDADES COMO OBJETOS!!
    actividad.hacer(self)
  }

  // Estas actividades son bastante variadas, y todos los días se inventan más y más

  // POR ESA RAZON NO PUEDEN SER METODOS!!
  // ADEMAS CUANDO REALIZO EL METODO DE REALIZAR TODAS LAS ACTIVIDADES, REALIZO TODAS LAS QUE TENGO EN LA LISTA
  // SINO DEBERIA IR INCLUYENDO UNA POR UNA CUANDO APAREZCA UNA NUEVA ACTIVIDAD!!

  /*
  method tomarVino() {
    self.disminuirNivelDeIluminacion(10)
    self.agregarHonorifico("el borracho")
  }

  method juntarseEnElAgora(otroFilosofo) {
    self.aumentarNivelDeIluminacion(otroFilosofo.nivelDeIluminacion() / 10)
  }

  method admirarElPaisaje(){}

  method meditarBajoUnaCascada(cascada) {
    self.aumentarNivelDeIluminacion(10 * cascada.metros())
  }

  method practicarUnDeporte(deporte) {
    self.rejuvenecer(deporte.cantidadParaRejuvenecer()) // le paso la pelota al deporte
  }
  */

  // Los filosofos tambien envejecen:

  method pasajeDelTiempo() {
    self.envejecer(1)
  }

  method verificarCumpleanito() {
    if(self.esElCumpleanito()) self.aumentarNivelDeIluminacion(10)
    self.verificarJubilacion()
  }

  method verificarJubilacion(){
    if(self.edad() == 60) self.agregarHonorifico("el sabio ")
  }

  // 3) Hacer que un filósofo viva un día. Esto implica realizar todas sus actividades y 
  // el pasaje del tiempo que afecta al sujeto.

  /*
  method vivirUnDia(otroFilosofo, cascada, deporte) {
    self.realizarTodasLasActividades(otroFilosofo, cascada, deporte)
    self.envejecerUnDia()
  }

  method realizarTodasLasActividades(otroFilosofo, cascada, deporte) {
    self.tomarVino()
    self.juntarseEnElAgora(otroFilosofo)
    self.admirarElPaisaje()
    self.meditarBajoUnaCascada(cascada)
    self.practicarUnDeporte(deporte)
    // OTRAS...

    // ESTO ESTARIA MAL, CADA VEZ QUE AGREGUE UN METODO, LO TENGO QUE AGREGAR ACA, NO SERIA ESCALABLE MI CODIGO!!
  }
  */

  method vivirUnDia(){
    self.realizarActividades()    // realizo las actividades
    self.pasajeDelTiempo()        // paso un dia (es decir, envejece un dia +1)
    self.verificarCumpleanito()   // chequeo si es un cumple!! (dentro chequeo su jubilacion)
  }

  method realizarActividades() {
    actividades.forEach({actividad => self.hacerActividad(actividad)})
  }

}

// Algunos filosofos..


// ACTIVIDADES COMO OBJETOS 
// Estas actividades son bastante variadas, y todos los días se inventan más y más

object tomarVino {
    method hacer(filosofo){
      filosofo.disminuirNivelDeIluminacion(10)
      filosofo.agregarHonorifico("el borracho ")
    }
  }

class JuntarseEnElAgora {
  const otroFilosofo

  method hacer(filosofo) {
    filosofo.aumentarNivelDeIluminacion(otroFilosofo.nivelDeIluminacion() / 10)
  }
}

object admirarElPaisaje {
  method hacer(filosofo){
    // No hace nada realmente!!
  }
}

class MeditarBajoUnaCascada {
  const cascada

  method hacer(filosofo) {
    filosofo.aumentarNivelDeIluminacion(10 * cascada.metros())
  }
}

class PracticarUnDeporte {
  const deporte

  method hacer(filosofo) {
    filosofo.rejuvenecer(deporte.cantidadParaRejuvenecer()) // le paso la pelota al deporte
  }
}

// PUNTO 6 -- NUEVOS FILOSOFOS

class FilosofoContemporaneo inherits Filosofo {

  override method presentarse() = "hola".toString()

  // Su nivel de iluminación es el mismo a menos que ame admirar el paisaje, en cuyo caso se quintuplica.
  override method nivelDeIluminacion() = super() * self.coeficienteIluminacion()

  method coeficienteIluminacion() = if(self.amaAdmirarElPaisaje()) 5 else 1
  method amaAdmirarElPaisaje() = actividades.contains(admirarElPaisaje)
}

// CASCADA
class Cascada {
  const metros
  
  method metros() = metros
}

// DEPORTES
object futbol {
  method cantidadParaRejuvenecer() = 1
}

object polo {
  method cantidadParaRejuvenecer() = 2
}

object waterpolo {
  method cantidadParaRejuvenecer() = polo.cantidadParaRejuvenecer() * 2
}

// DISCUSION
class Discusion {
  const argumentos = [] // toda discusion esta compuesta por argumentos
  const unPartido
  const otroPartido
  
  // 5) Discusion es buena?

  method esBuena() = unPartido.esBueno() and otroPartido.esBueno()

  /*

  DEMASIADA REPETICION DE LOGICA, SIMPLEMENTE PUEDE DELEGAR Y YA TA

  method esBuena(unPartido, otroPartido) = 
    self.argumentosPresentadosBuenos(unPartido, otroPartido) and self.ambosFilosofosEstanEnLoCorrecto(unPartido, otroPartido)

  method argumentosPresentadosBuenos(unPartido, otroPartido) =
    unPartido.argumentosEnriquecedoresMitad() and otroPartido.argumentosEnriquecedoresMitad()

  method ambosFilosofosEstanEnLoCorrecto(unPartido, otroPartido) =
    unPartido.suFilosofoEstaEnloCorrecto() and otroPartido.suFilosofoEstaEnloCorrecto()
  */

}

class Argumento {     // Todo argumento tiene una descripción y una naturaleza
  const descripcion 
  const naturaleza

  method cantidadPalabras() = descripcion.words()
  method esPregunta() = descripcion.last("?") // descripcion.endsWith("?")

  // 4) Saber si un argumento es enriquecedor.
  method esEnriquecedor() = naturaleza.enriquece(self)   // La naturaleza de un argumento determina la intención con la cual se usan sus palabras y si enriquecen la discusión.

}

// TIPOS DE NATURALEZA
object estoica {
  method enriquece(argumento) = true
}

object moralista {
  method enriquece(argumento) = argumento.cantidadPalabras() >= 10 
}

object esceptica {
  method enriquece(argumento) = argumento.esPregunta()
}

object cinica {
  method enriquece(argumento) = 1.randomUpTo(100) <= 30  // son enriquecedores el 30% de las veces. (si sale un numero entre 1 y 30 de 100 posibles)
}

// Existen argumentos de naturalezas combinadas. Estos argumentos presentan múltiples naturalezas 
// y son enriquecedores si y sólo si todas las naturalezas son enriquecedoras.

class NaturalezasCombinadas {
  const naturalezas = []
  method enriquece(argumento) = naturalezas.all({naturaleza => naturaleza.enriquece(argumento)})
}

class Partido { // cada partido está compuesto por un único filósofo (y sus argumentos).
  const filosofo
  const property argumentos = []

  method esBueno() = self.suFilosofoEstaEnloCorrecto() and self.tieneBuenosArgumentos()

  // al menos el 50% de los argumentos presentados son enriquecedores 
  method tieneBuenosArgumentos() = self.cantArgumentosEnriquecedores() >= (self.cantArgumentos() / 2)

  method cantArgumentos() = argumentos.size()

  method cantArgumentosEnriquecedores() = argumentos.count({argumento => argumento.esEnriquecedor()})

  method suFilosofoEstaEnloCorrecto() = filosofo.estaEnLoCorrecto()

}