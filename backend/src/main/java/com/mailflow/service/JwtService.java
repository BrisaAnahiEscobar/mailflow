package com.mailflow.service;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import javax.crypto.SecretKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

	@Value("${jwt.secret}")
	private String secret;

	@Value("${jwt.expiration}")
	private Long expiration;

	private SecretKey getKey() {
		return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
	}

	public String generarToken(String email, Long usuarioId) {
		return Jwts.builder()
				.subject(email)
				.claim("usuarioId", usuarioId)
				.issuedAt(new Date())
				.expiration(new Date(System.currentTimeMillis() + expiration))
				.signWith(getKey())
				.compact();
	}

	public String extraerEmail(String token) {
		return Jwts.parser()
				.verifyWith(getKey())
				.build()
				.parseSignedClaims(token)
				.getPayload()
				.getSubject();
	}

	public boolean validarToken(String token) {
		try {
			Jwts.parser()
					.verifyWith(getKey())
					.build()
					.parseSignedClaims(token);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
}
