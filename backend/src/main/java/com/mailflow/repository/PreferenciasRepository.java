package com.mailflow.repository;

import com.mailflow.model.Preferencias;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface PreferenciasRepository extends JpaRepository<Preferencias, Long> {
	Optional<Preferencias> findByUsuarioId(Long usuarioId);
}