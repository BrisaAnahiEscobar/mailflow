package com.mailflow.exception;

public class TokenInvalidoException extends RuntimeException {
	public TokenInvalidoException(String mensaje) { super(mensaje); }
	public TokenInvalidoException(String mensaje, Throwable causa) { super(mensaje, causa); }
}