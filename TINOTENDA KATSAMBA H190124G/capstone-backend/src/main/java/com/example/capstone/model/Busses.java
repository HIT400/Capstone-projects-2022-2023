package com.example.capstone.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Busses {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String bus_id;
    private String bus_number;
    private String bus_driver_name;
    private String bus_route_name;
    private String id;
}
