package com.example.capstone.service;

import com.example.capstone.model.Busses;
import com.example.capstone.repository.BussesRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class BussesService {
    private final BussesRepository bussesRepository;

    //save buses
    public Busses saveBusses(Busses busses) {
        return bussesRepository.save(busses);
    }

    //list all buses
    public List<Busses> listAllBusses() {
        return bussesRepository.findAll();
    }

    //delete buses
    public String deleteById(String id){
        bussesRepository.deleteById(id);
        return """
                bus with id %s deleted succesfully""".formatted(id);
    }
}
