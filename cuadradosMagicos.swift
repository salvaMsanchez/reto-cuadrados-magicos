import Foundation

final class RetoCaso {

	// Atributos
	//---
	private var ladoCuadrado: Int = 0
	private var cuadradoMagico: [[Int]] = []
	private var diabolico: Bool = false
	private var esoterico: Bool = false
	private var constanteMagica: Int = 0
	private var cm2: Double = 0

	// Métodos
	//---

	// Método que se encarga de leer la entrada del usuario respecto a la longitud del lado del cuadrado. 
	// Dicho valor lo almacena en el atributo de clase `ladoCuadrado`. Si es 0, devuelve `false` y el programa termina
	private func leerEntradaLadoCuadrado() -> Bool {

		while true {
			if let entradaUsuario = readLine(),
			let entradaComoInt = Int(entradaUsuario),
			entradaComoInt >= 0 {
				if entradaComoInt == 0 {
					return false
				} else {
					if entradaComoInt >= 2, entradaComoInt <= 1_024 {
						ladoCuadrado = entradaComoInt
						cuadradoMagico = Array(repeating: Array(repeating: 0, count: ladoCuadrado), count: ladoCuadrado)
						return true
					} else {
						print("Error. Introduce un número entre 2 y 1024 para el lado del cuadrado.")
					}
				}
			} else {
				print("Error. Introduce un número positivo. Recuerde que introduciendo el número 0, se sale del programa")
			}
		}

	}

	// Método que se ocupa de leer la entrada dada por el usuario en el que enumera el contenido del cuadrado y, a continuación,
	// este es traducido y almacenado en una matriz (array de arrays) representante del cuadrado de n lados
	private func leerEntradaContenidoCuadrado() {

		var contenidoCorrecto: Bool = false

		while !contenidoCorrecto {

			if let entradaContenidoString: String = readLine() {
				let entradaContenido: [String] = entradaContenidoString.components(separatedBy: " ")
				let numerosAIntroducir: Int = Int(pow(Double(ladoCuadrado), Double(2)))
				if entradaContenido.count != numerosAIntroducir {
					print("Error: Has escrito \(entradaContenido.count) caracteres. Debes introducir \(numerosAIntroducir) números y con un espacio de separación para completar tu cuadrado de \(ladoCuadrado) lados.")
				} else {
					var contadorLongitudCuadradoMagico: Int = 0
					var contadorIndiceElementoCuadradoMagico: Int = 0
					for num in entradaContenido {
						if let numero: Int = Int(String(num)) {
							cuadradoMagico[contadorLongitudCuadradoMagico][contadorIndiceElementoCuadradoMagico] = numero
							if contadorIndiceElementoCuadradoMagico == 0 {
								contadorIndiceElementoCuadradoMagico += 1
							} else if contadorIndiceElementoCuadradoMagico == ladoCuadrado - 1 {
								contadorIndiceElementoCuadradoMagico = 0
								contadorLongitudCuadradoMagico += 1
							} else {
								contadorIndiceElementoCuadradoMagico += 1
							}
							contenidoCorrecto = true
						} else {
							print("Error: Has introducido caracteres no permitidos. Solo se permiten números enteros.")
							break
						}

					}
				}
			}
		}
	}

	// Método que suma las tres columnas, las tres filas y las dos diagonales, y las almacena en un array para, luego, verificar
	// si todos los resultados son iguales (diabólico) o no
	private func esDiabolico() {

		// Columnas
		var columnas: [Int] = Array(repeating: 0, count: ladoCuadrado)
		for (indice, _ ) in cuadradoMagico.enumerated() {
			for numColumna in 0...ladoCuadrado - 1 {
				columnas[numColumna] = columnas[numColumna] + cuadradoMagico[indice][numColumna]
			}
		}

		// Filas
		var filas: [Int] = Array(repeating: 0, count: ladoCuadrado)
		for (numFila, _ ) in cuadradoMagico.enumerated() {
			for indice in 0...ladoCuadrado - 1 {
				filas[numFila] = filas[numFila] + cuadradoMagico[numFila][indice]
			}
		}

		// Diagonales
		var diagonales: [Int] = Array(repeating: 0, count: 2)

			// Diagonal izquierda-derecha
		var contadorIzquierda: Int = 0
		for (indice, _ ) in cuadradoMagico.enumerated() {
			diagonales[0] = diagonales[0] + cuadradoMagico[indice][contadorIzquierda]
			contadorIzquierda += 1
		}

			// Diagonal derecha-izquierda
		var contadorDerecha: Int = ladoCuadrado - 1
		for (indice, _ ) in cuadradoMagico.enumerated() {
			diagonales[1] = diagonales[1] + cuadradoMagico[indice][contadorDerecha]
			contadorDerecha -= 1
		}

		// Unión de los arrays que contienen los resultados de las sumas respecto a columnas, filas y diagonales
		let sumas: [Int] = columnas + filas + diagonales

		// Verificación de que las diversas sumas son iguales o no
		for (indice, valor) in sumas.enumerated() {
			if indice == sumas.count - 1 {
				break
			} else if valor != sumas[indice + 1] {
				diabolico = false
				break
			} else {
				diabolico = true
			}
		}

		if diabolico {
			// Almacenamos constante mágica porque la necesitaremos para la comprobación de si es esotérico o no
			constanteMagica = sumas[0]
		}

	}

	// Método para comprobar el primer condicionante para cumplir con el ser un cuadrado mágico diabólico esotérico:
	// Tiene las mismas cifras que el número de casillas. Es decir, siguen la serie de números naturales de 1 a n²
	private func mismasCifrasNumeroCasillas() -> Bool {

		var cuadradoMagicoArray: [Int] = []

		for elemento in cuadradoMagico {
		  for num in elemento {
		    cuadradoMagicoArray.append(num)
		  }
		}

		var contador: Int = 0
		for num in 1...9 {
		  if cuadradoMagicoArray.contains(num) {
		    contador += 1
		  }
		}

		if contador == 9 {
		  return true
		} else {
		  return false
		}

	}

	// Método para comprobar el segundo condicionante para cumplir con el ser un cuadrado mágico diabólico esotérico: 
	// La suma de sus esquinas debe ser la constante mágica 2 (CM2) -> CM2 = (4 * CM) / n
	private func esquinasConstanteMagica(_ primerCondicionante: Bool) -> Bool {

		if primerCondicionante {

			var sumaEsquinas: Int = 0

			for (indice, _ ) in cuadradoMagico.enumerated() {
			  if indice == 0 {
			    sumaEsquinas += cuadradoMagico[indice][0]
			    sumaEsquinas += cuadradoMagico[indice][ladoCuadrado - 1]
			  }

			  if indice == ladoCuadrado - 1 {
			    sumaEsquinas += cuadradoMagico[indice][0]
			    sumaEsquinas += cuadradoMagico[indice][ladoCuadrado - 1]
			  }

			}

			
			let cm2: Double = (4 * Double(constanteMagica)) / Double(ladoCuadrado)

			let segundoCondicionante: Bool = cm2 == Double(sumaEsquinas) ? true : false

			// Almacenamiento de la constante mágica 2 en atributo de clase ya que la necesitaremos en más partes de nuestro código
			self.cm2 = cm2

			return segundoCondicionante

		} else {
			return false
		}

	}


	private func tercerYCuartoCondicionante(_ segundoCondicionante: Bool) -> Bool {

		if segundoCondicionante {

			// Si n es impar
			if ladoCuadrado % 2 != 0 {

				var comprobaciones: [Bool] = []

				// Comprobar: La suma de las cifras de las cuatro casillas de la mitad de los laterales suman la constante mágica 2
				var sumaMitadLaterales: Int = 0

				let mitadLadoCuadrado: Int = ladoCuadrado / 2

				let mitadLateral: Int = ladoCuadrado - mitadLadoCuadrado

				for (indice, elemento) in cuadradoMagico.enumerated() {
				  if indice == 0 {
				sumaMitadLaterales += (elemento[mitadLateral - 1])
				  } else if indice == mitadLateral - 1 {
				    sumaMitadLaterales += (elemento[0])
				    sumaMitadLaterales += (elemento[ladoCuadrado - 1])
				  } else if indice == ladoCuadrado - 1 {
				    sumaMitadLaterales += (elemento[mitadLateral - 1])
				  }
				}

				if Double(sumaMitadLaterales) == cm2 {
					comprobaciones.append(true)
				} else {
					comprobaciones.append(false)
				}

				// Comprobar: Si se multiplica el valor de la casilla central por 4, se obtiene la constante mágica 2
				var numCentral: Int = 0
				for (indice, elemento) in cuadradoMagico.enumerated() {
				  if indice == mitadLateral - 1 {
				    numCentral += (elemento[mitadLateral - 1])
				  } 
				}

				if Double(numCentral * 4) == cm2 {
					comprobaciones.append(true)
				} else {
					comprobaciones.append(false)
				}

				// Retorno comprobaciones
				if comprobaciones[0] == true, comprobaciones[1] == true {
					return true
				} else {
					return false
				}

			} else { // Si n es par:

				var comprobaciones: [Bool] = []

				// Comprobar: La suma de las dos casillas centrales de cada uno de los cuatro laterales
				// suman el doble de la constante mágica 2 (2 · CM2)
				var sumaCasillasCentrales: Int = 0

				let mitadLadoCuadrado: Int = ladoCuadrado / 2

				for (indice, elemento) in cuadradoMagico.enumerated() {
				  if indice == 0 {
				    sumaCasillasCentrales += (elemento[mitadLadoCuadrado - 1])
				    sumaCasillasCentrales += (elemento[mitadLadoCuadrado])
				  } else if indice == mitadLadoCuadrado - 1 {
				    sumaCasillasCentrales += (elemento[0])
				    sumaCasillasCentrales += (elemento[ladoCuadrado - 1])
				  } else if indice == mitadLadoCuadrado {
				    sumaCasillasCentrales += (elemento[0])
				    sumaCasillasCentrales += (elemento[ladoCuadrado - 1])
				  } else if indice == ladoCuadrado - 1 {
				    sumaCasillasCentrales += (elemento[mitadLadoCuadrado - 1])
				    sumaCasillasCentrales += (elemento[mitadLadoCuadrado])
				  }
				}

				if Double(sumaCasillasCentrales) == 2 * cm2 {
					comprobaciones.append(true)
				} else {
					comprobaciones.append(false)
				}

				// Comprobar: La suma de las cuatro casillas centrales da como resultado la constante mágica 2
				var sumaCasillasCentro: Int = 0

				for (indice, elemento) in cuadradoMagico.enumerated() {
				  if indice == mitadLadoCuadrado - 1 {
				    sumaCasillasCentro += (elemento[mitadLadoCuadrado - 1])
				    sumaCasillasCentro += (elemento[mitadLadoCuadrado])
				  } else if indice == mitadLadoCuadrado {
				    sumaCasillasCentro += (elemento[mitadLadoCuadrado - 1])
				    sumaCasillasCentro += (elemento[mitadLadoCuadrado])
				  }
				}

				if Double(sumaCasillasCentro) == cm2 {
					comprobaciones.append(true)
				} else {
					comprobaciones.append(false)
				}

				// Retorno comprobaciones
				if comprobaciones[0] == true, comprobaciones[1] == true {
					return true
				} else {
					return false
				}
			}


		} else {
			return false
		}
		

	}

	private func reiniciarAtributosDeClase() {
		ladoCuadrado = 0
		cuadradoMagico = []
		diabolico = false
		esoterico = false
		constanteMagica = 0
		self.cm2 = 0
	}

	func logicaReto() {
		
		while true {

			let seguirAnalizandoCuadrados: Bool = leerEntradaLadoCuadrado()
			if seguirAnalizandoCuadrados {

				leerEntradaContenidoCuadrado()

				esDiabolico()

				if diabolico {

					let primerCondicionante: Bool = mismasCifrasNumeroCasillas()
					let segundoCondicionante: Bool = esquinasConstanteMagica(primerCondicionante)
					let tercerYCuartoCondicionante: Bool = tercerYCuartoCondicionante(segundoCondicionante)

					if primerCondicionante, segundoCondicionante, tercerYCuartoCondicionante {
						print("ESOTÉRICO")
						reiniciarAtributosDeClase()
					} else {
						print("DIABÓLICO")
						reiniciarAtributosDeClase()
					}

				} else {
					print("NO")
					reiniciarAtributosDeClase()
				}

			} else {
				break
			}
			
		}

	}

}

// Main
let reto: RetoCaso = RetoCaso()
reto.logicaReto()
