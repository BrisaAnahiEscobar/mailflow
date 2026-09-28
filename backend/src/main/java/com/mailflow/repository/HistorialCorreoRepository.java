package com.mailflow.repository;

import com.mailflow.model.HistorialCorreo;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface HistorialCorreoRepository extends JpaRepository<HistorialCorreo, Long> {
	List<HistorialCorreo> findByUsuarioIdOrderByFechaEscuchaDesc(Long usuarioId);
}