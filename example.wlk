
class Nave {
  var property velocidad 
  var property direccion
  var property combustible
  method acelerar(cuanto) {velocidad = 100000.min(velocidad + cuanto)}
  method desacelerar(cuanto) {velocidad = 0.max(velocidad - cuanto)}
  method irHaciaElSol() {direccion = 10}
  method escaparDelSol() {direccion = -10}
  method ponerseParaleloAlSol() {direccion = 0}
  method acercarseUnPocoAlSol() {direccion = 10.min(direccion + 1)}
  method alejarseUnPocoDelSol() {direccion = -10.max(direccion - 1)}
  method cargarCombustible(unaCantidad) {combustible += unaCantidad}
  method descargarCombustible(unaCantidad) {combustible -= unaCantidad}
  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  method estaTranquila() = combustible >= 4000 and velocidad < 12000
  method escapar() {}
  method avisar() {}
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method estaDeRelajo() = self.estaTranquila() 
}

class NaveBaliza inherits Nave {
  var property colorBaliza = "verde"
  var cambiosDeBaliza = 0

  method cambiarColorDeBaliza(colorNuevo) {
    colorBaliza = colorNuevo
    cambiosDeBaliza += 1
  }
  override method prepararViaje() {
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method estaTranquila() = super() and (colorBaliza != "rojo")
  override method escapar() {self.irHaciaElSol()}
  override method avisar() {self.cambiarColorDeBaliza("rojo")}
  method tienePocaActividad() = cambiosDeBaliza == 0
  override method estaDeRelajo() = super() and self.tienePocaActividad()
}

class NaveDePasajeros inherits Nave {
  var property cantidadPasajeros
  var property  racionesDeComida = 0
  var property racionesDeBebida = 0
  var racionesDeComidaServidas = 0
  var racionesDeBebidaServidas = 0

  method cargarComida(unaCantidad) {racionesDeComida += unaCantidad}
  method cargarBebida(unaCantidad) {racionesDeBebida += unaCantidad}
  method servirComida(unaCantidad) {
    racionesDeComida -= unaCantidad
    racionesDeComidaServidas += 1  
  }
  method servirBebida(unaCantidad) {
    racionesDeBebida -= unaCantidad
    racionesDeBebidaServidas += 1  
  }
  override method prepararViaje() {
    super()
    self.cargarComida(4 * cantidadPasajeros)
    self.cargarBebida(6 * cantidadPasajeros)
    self.acercarseUnPocoAlSol()
  }
  override method escapar() {velocidad = velocidad * 2}
  override method avisar() {
    self.servirComida(1 * cantidadPasajeros) 
    self.servirBebida(2 * cantidadPasajeros) 
  }
  method tienePocaActividad() = racionesDeComidaServidas < 50
  override method estaDeRelajo() = super() and self.tienePocaActividad()
}

class NaveDeCombate inherits Nave {
  var property estaInvisible = true
  var property misilesDesplegados = false
  const property mensajesEmitidos = []

  method ponerseVisible() {estaInvisible = true}
  method ponerseInvisible() {estaInvisible = false}
  method desplegarMisiles() {misilesDesplegados = true}
  method replegarMisiles() {misilesDesplegados = false}
  method emitirMensaje(mensaje) {mensajesEmitidos.add(mensaje)}
  method primerMensajeEmitido() = mensajesEmitidos.first()
  method ultimoMensajeEmitido() = mensajesEmitidos.last()
  method esEscueta() = mensajesEmitidos.any({m => m.length() > 30})
  method emitioMensaje() = not mensajesEmitidos.isEmpty()
  override method prepararViaje() {
    super()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }
  override method estaTranquila() = super() and (misilesDesplegados == false)
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {self.emitirMensaje("Amenaza recibida")}
}

class NaveHospital inherits NaveDePasajeros {
  var quirofanosPreparados = false

  method prepararQuirofanos() {quirofanosPreparados = true}
  override method estaTranquila() = super() and (quirofanosPreparados == false)
  override method recibirAmenaza() {
    super()
    self.prepararQuirofanos()
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
  override method estaTranquila() = super() and (estaInvisible != true)
  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}