SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `fiscales_db`
--
-- -----------------------
-- Usuario
-- -----------------------
CREATE TABLE `gen_user_status` (
  `id` int(11) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_user_level` (
  `id` int(11) NOT NULL,
  `description` varchar(45) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `firebase_uid` varchar(255) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `national_id` varchar(45) DEFAULT NULL,
  `level_id` int(11) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `avatar` blob,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user_id` int(11) NOT NULL,
  `update_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`user_name`),
  KEY `user_level_idx` (`level_id`),
  KEY `user_sttatus_idx` (`status_id`),
  CONSTRAINT `user_level` FOREIGN KEY (`level_id`) REFERENCES `gen_user_level` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_status` FOREIGN KEY (`status_id`) REFERENCES `gen_user_status` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------
-- Seguridad
-- -----------------------

CREATE TABLE `sec_privilege` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `privilege_user_idx` (`create_user_id`),
  CONSTRAINT `privilege_user` FOREIGN KEY (`create_user_id`) REFERENCES `gen_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sec_rol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `rol_user_idx` (`create_user_id`),
  CONSTRAINT `rol_user` FOREIGN KEY (`create_user_id`) REFERENCES `gen_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `sec_rol_privilege` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rol_id` int(11) NOT NULL,
  `privilege_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Unique` (`rol_id`,`privilege_id`),
  KEY `rol_privilege_privilege_idx` (`privilege_id`),
  KEY `rol_privilege_create_user_idx` (`create_user_id`),
  CONSTRAINT `rol_privilege_create_user` FOREIGN KEY (`create_user_id`) REFERENCES `gen_user` (`id`),
  CONSTRAINT `rol_privilege_privilege` FOREIGN KEY (`privilege_id`) REFERENCES `sec_privilege` (`id`),
  CONSTRAINT `rol_privilege_rol` FOREIGN KEY (`rol_id`) REFERENCES `sec_rol` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



CREATE TABLE `gen_user_rol` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `rol_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_rol_user_idx` (`user_id`),
  KEY `user_rol_rol_idx` (`rol_id`),
  KEY `user_rol_create_user_idx` (`create_user_id`),
  CONSTRAINT `user_rol_create_user` FOREIGN KEY (`create_user_id`) REFERENCES `gen_user` (`id`),
  CONSTRAINT `user_rol_rol` FOREIGN KEY (`rol_id`) REFERENCES `sec_rol` (`id`),
  CONSTRAINT `user_rol_user` FOREIGN KEY (`user_id`) REFERENCES `gen_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- -----------------------
-- Estructura territorial
-- -----------------------

CREATE TABLE `gen_distrito` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

  -- Existen distintos modelos entre provincias / BsAs,Mza,Tucuman / CABA en la seccion, pero unificamos todo en seccion para mantener la estructura estandar
  -- -----------------------
CREATE TABLE `gen_seccion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `distrito_id` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `seccion_distrito_idx` (`distrito_id`),
  CONSTRAINT `seccion_distrito` FOREIGN KEY (`distrito_id`) REFERENCES `gen_distrito` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_circuito` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seccion_id` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `circuito_seccion_idx` (`seccion_id`),
  CONSTRAINT `circuito_seccion` FOREIGN KEY (`seccion_id`) REFERENCES `gen_seccion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_local_comicio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `circuito_id` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `localcomicio_circuito_idx` (`circuito_id`),
  CONSTRAINT `localcomicio_circuito` FOREIGN KEY (`circuito_id`) REFERENCES `gen_circuito` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `gen_mesa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `local_comicio_id` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mesa_localcomicio_idx` (`local_comicio_id`),
  CONSTRAINT `mesa_localcomicio` FOREIGN KEY (`local_comicio_id`) REFERENCES `gen_local_comicio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------
-- Comicio
-- -----------------------

CREATE TABLE `com_comicio_estado` (
  `id` INT NOT NULL,
  `descripcion` VARCHAR(45) NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `com_comicio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) NOT NULL,
  `estado_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comicio_comicioestado_idx` (`estado_id`),
  CONSTRAINT `comicio_comicioestado` FOREIGN KEY (`estado_id`) REFERENCES `com_comicio_estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `com_comicio_categoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comicio_id` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comiciocategoria_comicio_idx` (`comicio_id`),
  CONSTRAINT `comiciocategoria_comicio` FOREIGN KEY (`comicio_id`) REFERENCES `com_comicio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `com_comicio_fuerza_politica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comicio_id` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comiciofuerzapolitica_comicio_idx` (`comicio_id`),
  CONSTRAINT `comiciofuerzapolitica_comicio` FOREIGN KEY (`comicio_id`) REFERENCES `com_comicio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `com_comisio_candidato` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comicio_categoria_id` int(11) NOT NULL,
  `comicio_fuerza_politica_id` int(11) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comiciocandidato_comiciofuerzapolitica_idx` (`comicio_fuerza_politica_id`),
  KEY `comiciocandidato_comiciocategoria_idx` (`comicio_categoria_id`),
  CONSTRAINT `comiciocandidato_comiciocategoria` FOREIGN KEY (`comicio_categoria_id`) REFERENCES `com_comicio_categoria` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `comiciocandidato_comiciofuerzapolitica` FOREIGN KEY (`comicio_fuerza_politica_id`) REFERENCES `com_comicio_fuerza_politica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
