package com.example.capstone.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class Driver {
    @Id
    @GeneratedValue( strategy = GenerationType.UUID)
    private String id;
    private String firstname;
    private String lastname;
    private String drivers_license;
    private String phone;
    private String password;
    private String email;
    private String bus_number;
}
