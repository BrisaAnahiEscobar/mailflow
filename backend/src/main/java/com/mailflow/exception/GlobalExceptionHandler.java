package com.mailflow.exception;

import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

	public record ErrorResponse(int status, String mensaje, Map<String, String> detalles) {
	}

	@ExceptionHandler(TokenInvalidoException.class)
	public ResponseEntity<ErrorResponse> tokenInvalido(TokenInvalidoException e) {
		return respuesta(HttpStatus.UNAUTHORIZED, e.getMessage(), Map.of());
	}

	@ExceptionHandler(RecursoNoEncontradoException.class)
	public ResponseEntity<ErrorResponse> noEncontrado(RecursoNoEncontradoException e) {
		return respuesta(HttpStatus.NOT_FOUND, e.getMessage(), Map.of());
	}

	@ExceptionHandler(MethodArgumentNotValidException.class)
	public ResponseEntity<ErrorResponse> validacion(MethodArgumentNotValidException e) {
		Map<String, String> detalles = new LinkedHashMap<>();
		e.getBindingResult().getFieldErrors()
				.forEach(f -> detalles.put(f.getField(), f.getDefaultMessage()));
		return respuesta(HttpStatus.BAD_REQUEST, "Datos inválidos", detalles);
	}

	private ResponseEntity<ErrorResponse> respuesta(HttpStatus s, String msg, Map<String, String> d) {
		return ResponseEntity.status(s).body(new ErrorResponse(s.value(), msg, d));
	}
}