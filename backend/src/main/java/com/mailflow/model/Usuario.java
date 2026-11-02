package com.mailflow.model;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.Data;


@Data
@Entity
@Table(name = "usuarios")

public class Usuario {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "google_sub", unique = true, nullable = false)
	private String googleSub;

	@Column(nullable = false)
	private String email;

	@Column(name = "created_at")
	private LocalDateTime createdAt;

	@OneToOne(mappedBy = "usuario", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	private Preferencias preferencias;

	@PrePersist
	public void prePersist() {
		this.createdAt = LocalDateTime.now();
	}

}

