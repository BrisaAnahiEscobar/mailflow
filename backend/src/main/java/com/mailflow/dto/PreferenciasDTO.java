package com.mailflow.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PreferenciasDTO {

	@NotBlank
	@Pattern(regexp = "^[a-z]{2,3}(-[A-Z]{2})?$", message = "Formato de idioma inválido (ej. es-ES)")
	private String idiomaTts;

	@NotNull
	@DecimalMin("0.1")
	@DecimalMax("1.0")
	private Double velocidadTts;

	@NotNull
	@DecimalMin("0.5")
	@DecimalMax("2.0")
	private Double pitchTts;
}