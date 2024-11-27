class Persona {
    var property posicion
    var criterioPasarElementos
    const elementosCerca = []
    var criterioComer
    const comidasIngeridas = []

    method pasarElemento(otraPersona, elemento) {
        criterioPasarElementos.pasarElemento(self, otraPersona, elemento)
    }

    method tieneElemento(elemento) = elementosCerca.contains(elemento)

    method primerElemento() = elementosCerca.first()

    method removerElemento(elemento) {
        elementosCerca.remove(elemento)
    }

    method removerElementos(elementos) {
        elementosCerca.remove(elementos)
    }

    method agregarElemento(elemento) {
        elementosCerca.add(elemento)
    }

    method agregarElementos(elementos) {
        elementosCerca.addAll(elementos)
    }

    method comerSiQuiere(comida) {
        if (self.quiereComer(comida)) {
            self.registrarComida(comida)
        }
    }

    method quiereComer(comida) = criterioComer.quiereComer()

    method registrarComida(comida) {
        comidasIngeridas.add(comida)
    }

    method estaPipon() = comidasIngeridas.any({ comidaIngerida => comidaIngerida.esPesada() })

    method comioAlgo() = !comidasIngeridas.isEmpty()

    method laEstaPasandoBien() = self.comioAlgo() && self.laEstaPasandoBienExtra()

    method laEstaPasandoBienExtra()

    method comioCarne() = comidasIngeridas.any({ comidaIngerida => comidaIngerida.esCarne() })

    method cantidadElementos() = elementosCerca.lenth()
}


object criterioElementosSordo {
    method pasarElemento(aQuienLePiden, quienPide, elemento) {
        const primerElementoAQuienLePiden = aQuienLePiden.primerElemento()
        quienPide.agregarElemento(primerElementoAQuienLePiden)
        aQuienLePiden.removerElemento(primerElementoAQuienLePiden)
    }
}

object criterioElementosPasarTodos {
    method pasarElemento(aQuienLePiden, quienPide, elemento) {
        const elementos = aQuienLePiden.elementosCerca()
        quienPide.agregarElementos(elementos)
        aQuienLePiden.removerElementos(elementos)
    }
}

object criterioElementosIntercambiarPosiciones {
    method pasarElemento(aQuienLePiden, quienPide, elemento) {
        const posicionAlQueLePiden = aQuienLePiden.posicion()
        aQuienLePiden.posicion(quienPide.posicion())
        quienPide.posicion(posicionAlQueLePiden)
    }
}

object criterioElementosTeLoPasoNomas {
    method pasarElemento(aQuienLePiden, quienPide, elemento) {
        quienPide.agregarElemento(elemento)
        aQuienLePiden.removerElemento(elemento)
    }
}


class Comida {
    const property calorias
    const property esCarne

    method esPesada() = calorias > 500 // Si este 500 es "el mismo" 500 que el de las calorias recomendadas por la OMS, entonces crearia un objeto llamado oms, y pondria en ese unico objeto el numero magico 500
}

object criterioComerVegetariano {
    method quiereComer(comida) = !comida.esCarne()
}

object criterioComerDietetico {
    var property caloriasRecomendadasPorComidaOMS = 500 // Si no fuese var, no se podria configurar en tiempo de ejecucion. Si no fuese property, no tendria un setter para configurarlo desde afuera del objeto

    method quiereComer(comida) = comida.calorias() < caloriasRecomendadasPorComidaOMS
}

object criterioComerAlternado {
    var quiereComer = false

    // Este metodo tiene un efecto colateral y ademas un retorno. Puede no agradar mucho quizas, pero me parecio lo mas sencillo y adecuado en este caso
    method quiereComer(comida) {
        quiereComer = !quiereComer
        return quiereComer
    }
}

object criterioComerCombinadito {
    const criterios = []

    method quiereComer(comida) = criterios.all({ criterio => criterio.quiereComer(comida) })
}


// El enunciado nunca dice los criterios ni la posicion iniciales que tienen estas siguientes personas.
// En este caso habria que preguntarle al analista (o al que corresponda) cuales son estos datos iniciales
object osky inherits Persona(posicion = 0, criterioPasarElementos = criterioElementosSordo, criterioComer = criterioComerVegetariano) {
    override method laEstaPasandoBienExtra() = true
}

object moni inherits Persona(posicion = 0, criterioPasarElementos = criterioElementosSordo, criterioComer = criterioComerVegetariano) {
    override method laEstaPasandoBienExtra() = self.posicion() == 11
}

object facu inherits Persona(posicion = 0, criterioPasarElementos = criterioElementosSordo, criterioComer = criterioComerVegetariano) {        
    override method laEstaPasandoBienExtra() = self.comioCarne()
}

object vero inherits Persona(posicion = 0, criterioPasarElementos = criterioElementosSordo, criterioComer = criterioComerVegetariano) {    
    override method laEstaPasandoBienExtra() = self.cantidadElementos() <= 3
}