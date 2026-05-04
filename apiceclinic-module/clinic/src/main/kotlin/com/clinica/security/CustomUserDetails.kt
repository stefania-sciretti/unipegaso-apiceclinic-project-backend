package com.clinica.security

import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

class CustomUserDetails(
    private val username: String,
    private val password: String,
    private val authorities: Collection<GrantedAuthority>,
    private val enabled: Boolean,
    val patientId: Long?
) : UserDetails {
    override fun getUsername() = username
    override fun getPassword() = password
    override fun getAuthorities() = authorities
    override fun isEnabled() = enabled
    override fun isAccountNonExpired() = true
    override fun isAccountNonLocked() = true
    override fun isCredentialsNonExpired() = true
}
