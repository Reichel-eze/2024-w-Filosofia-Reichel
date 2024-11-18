class Filosofo {
  const nombre
  var edad
  var dias = 0
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
  
  method edad() = edad

  method rejuvenecer(cantidad) { edad -= cantidad}

  method agregarHonorifico(honorifico) {
    honorificos.add(honorifico)
  }

  // 1) Pedirle a un filosofo que se presente...
  method presentarse() = nombre + self.honorificosSeparadosPorComa()
  method honorificosSeparadosPorComa() = honorificos.join(",") 

  // 2) Saber si un filosofo esta en lo correcto (Esto se cumple si su nivel de iluminación es mayor a 1000.)
  method estaEnLoCorrecto() = nivelDeIluminacion > 1000

  // Actividades que realiza el filosofo:

  method hacerActividad(actividad){   // ACTIVIDADES COMO OBJETOS!!
    actividad.hacer(self)
  }

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

  // Los filosofos tambien envejecen:

  method envejecerUnDia() {
    dias += 1
    if(dias == 365) self.envejecer()
  }

  method envejecer() {
    edad += 1
    self.aumentarNivelDeIluminacion(10)
    if(edad == 60) self.agregarHonorifico("el sabio ")
  }

  // 3) Hacer que un filósofo viva un día. Esto implica realizar todas sus actividades y 
  // el pasaje del tiempo que afecta al sujeto.

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
  }

  method realizarActividades() {
    actividades.forEach({actividad => self.hacerActividad(actividad)})
  }

}

// Algunos filosofos..
const diogenes = new Filosofo(nombre = "Diogenes: ", edad = 40, actividades = [], honorificos = ["el cinico "])
const confusio = new Filosofo(nombre = "Confusio: ", edad = 40, actividades = [], honorificos = ["el sabio ", "maestro "])

// ACTIVIDADES COMO OBJETOS

object tomarVinoV2 {
    method hacer(filosofo){
      filosofo.disminuirNivelDeIluminacion(10)
      filosofo.agregarHonorifico("el borracho")
    }
  }


// PUNTO 6 -- NUEVOS FILOSOFOS

class FilosofoContemporaneo inherits Filosofo {

  override method presentarse() = "hola".toString()
}


class Cascada {
  const metros
  
  method metros() = metros
}

object futbol {
  method cantidadParaRejuvenecer() = 1
}

object polo {
  method cantidadParaRejuvenecer() = 2
}

object waterpolo {
  method cantidadParaRejuvenecer() = polo.cantidadParaRejuvenecer() * 2
}

class Discusion {
  const argumentos = [] // toda discusion esta compuesta por argumentos

  method discutir(unPartido, otroPartido)

  // 5) Discusion es buena?
  method esBuena(unPartido, otroPartido) = 
    self.argumentosPresentadosBuenos(unPartido, otroPartido) and self.ambosFilosofosEstanEnLoCorrecto(unPartido, otroPartido)

  method argumentosPresentadosBuenos(unPartido, otroPartido) =
    unPartido.argumentosEnriquecedoresMitad() and otroPartido.argumentosEnriquecedoresMitad()

  method ambosFilosofosEstanEnLoCorrecto(unPartido, otroPartido) =
    unPartido.suFilosofoEstaEnloCorrecto() and otroPartido.suFilosofoEstaEnloCorrecto()

}

class Argumento {     // Todo argumento tiene una descripción y una naturaleza
  const descripcion 
  const naturaleza

  method cantidadPalabras() = descripcion.words()
  method terminaEnUnSignoDePregunta() = descripcion.last("?")

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
  method enriquece(argumento) = argumento.terminaEnUnSignoDePregunta()
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

  method argumentosEnriquecedoresMitad() = self.cantArgumentosEnriquecedores() >= (self.cantArgumentos() / 2)

  method cantArgumentos() = argumentos.size()
  method cantArgumentosEnriquecedores() = argumentos.contains({argumento => argumento.esEnriquecedor()})

  method suFilosofoEstaEnloCorrecto() = filosofo.estaEnLoCorrecto()

}