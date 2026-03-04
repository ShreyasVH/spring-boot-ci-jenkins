package com.example.demo.controllers;

import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class IndexController
{
    @GetMapping("/api")
    public Map<String, String> get(@RequestParam(value = "input") String input)
    {
        return new HashMap<String, String>(){{put("inputs", input);}};
    }

    @PostMapping("/api")
    public String post(@RequestBody Map<String, String> request)
    {
        for(String key: request.keySet())
        {
            System.out.println(key + ": " + request.get(key));
        }
        return "POST REQUEST";
    }

    @PutMapping("/api")
    public String put(@RequestBody Map<String, String> request)
    {
        for(String key: request.keySet())
        {
            System.out.println(key + ": " + request.get(key));
        }
        return "PUT REQUEST";
    }

    @DeleteMapping("/api")
    public String delete()
    {
        return "DELETE REQUEST";
    }
}
