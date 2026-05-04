package com.clinica.config

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping

/**
 * Forwards all non-API requests to Angular's index.html
 * so that client-side routing works when served from Spring Boot.
 */
@Controller
class SpaController {

    @RequestMapping(value = [
        "/{path:(?!api|swagger-ui|v3|webjars|actuator|h2-console)[^\\.]*}",
        "/{path:(?!api|swagger-ui|v3|webjars|actuator|h2-console)[^\\.]*}/**"
    ])
    fun forward(): String = "forward:/index.html"
}
