package com.exampl.myproject.web.rest;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.exampl.myproject.web.rest.dto.GreetingDto;

@RestController
public class ExampleRestController {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();

	@RequestMapping("/greeting")
	public GreetingDto greeting(@RequestParam(value = "name", defaultValue = "World") String name) {
		return new GreetingDto(counter.incrementAndGet(), String.format(template, name));
	}
}