package com.mailflow.dto;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class HistorialCorreoDTO {
	private Long id;
	private String gmailMessageId;
	private String asunto;
	private String remitente;
	private Boolean escuchado;
	private LocalDateTime fechaEscucha;
}
