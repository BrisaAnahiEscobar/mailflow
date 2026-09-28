package com.mailflow.repository;

import com.mailflow.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
	Optional<Usuario> findByGoogleSub(String googleSub);
	Optional<Usuario> findByEmail(String email);
}