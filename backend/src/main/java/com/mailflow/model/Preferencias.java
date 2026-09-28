package com.mailflow.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "preferencias")
public class Preferencias {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@OneToOne
	@JoinColumn(name = "usuario_id", nullable = false)
	private Usuario usuario;

	@Column(name = "idioma_tts")
	private String idiomaTts = "es-ES";

	@Column(name = "velocidad_tts")
	private Double velocidadTts = 0.45;

	@Column(name = "pitch_tts")
	private Double pitchTts = 1.0;
}