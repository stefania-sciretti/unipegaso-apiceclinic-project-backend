package com.clinica.dto

data class ErrorResponse(
    val status: Int,
    val error: String,
    val message: String,
    val fieldErrors: Map<String, String>? = null
)
