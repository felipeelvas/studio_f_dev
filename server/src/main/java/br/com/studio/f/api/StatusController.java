package br.com.studio.f.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StatusController {

    @GetMapping("/status")
    public String verificarStatus() {
        return "Studio F API funcionando";
    }
}