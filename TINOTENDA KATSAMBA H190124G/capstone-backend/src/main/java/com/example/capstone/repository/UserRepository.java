package com.example.capstone.repository;

import com.example.capstone.model.UserDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserDetails,String> {

    UserDetails findByEmailAndPassword(String email, String password);
    //sql to login
    @Query(
            "SELECT u FROM UserDetails u WHERE u.email =:email AND u.password =:password"
    )
    String authenticate(@Param("email") String email, @Param("password") String password);

    UserDetails findByEmail(String email);
}
