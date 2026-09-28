package com.mailflow.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "historial_correo")

public class HistorialCorreo {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne
	@JoinColumn(name = "usuario_id", nullable = false)
	private Usuario usuario;

	@Column(name = "gmail_message_id", nullable = false)
	private String gmailMessageId;

	@Column(name = "asunto")
	private String asunto;

	@Column(name = "remitente")
	private String remitente;

	@Column(name = "escuchado")
	private Boolean escuchado = false;

	@Column(name = "fecha_escucha")
	private LocalDateTime fechaEscucha;
}