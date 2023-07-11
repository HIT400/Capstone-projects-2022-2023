package com.example.capstone.service;

import com.example.capstone.model.UserDetails;
import com.example.capstone.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {
    private final UserRepository userRepository;

    //save user
    public UserDetails saveUser(UserDetails user){
        return userRepository.save(user);
    }

    //find driver by id
    public Optional<UserDetails> findById(String id){
        return userRepository.findById(id);
    }

    //login method
    public String authenticate(String email, String password) {
        userRepository.authenticate(email, password);
        return "Authenticated!";
    }

    public UserDetails login(String email, String password) throws Exception{
        return userRepository.findByEmail(email);
    }
    //find all
    public List<UserDetails> listAllUsers() {
        return userRepository.findAll();
    }

    public String deleteById(String id) {
        userRepository.deleteById(id);
        return """
                user with id %s ha been removed""".formatted(id);
    }


}
