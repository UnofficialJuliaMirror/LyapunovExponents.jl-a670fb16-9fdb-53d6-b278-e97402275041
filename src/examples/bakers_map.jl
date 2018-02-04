module BakersMap
export bakers_map
using ..ExampleBase: LEDemo, DiscreteExample

"""
Baker's map

* <https://en.wikipedia.org/wiki/Baker%27s_map>
"""
function bakers_map(;
        u0=[0.6, 0.4],
        tspan=10,
        num_attr=10000,
        atol=0, rtol=1e-5,
        kwargs...)
    @inline function phase_dynamics!(u_next, u, p, t)
        if u[1] < 0.5
            u_next[1] = 2 * u[1]
            u_next[2] = u[2] / 2
        else
            u_next[1] = 2 - 2 * u[1]
            u_next[2] = 1 - u[2] / 2
        end
    end
    @inline @views function tangent_dynamics!(u_next, u, p, t)
        phase_dynamics!(u_next[:, 1], u[:, 1], p, t)
        if u[1, 1] < 0.5
            u_next[1, 2:end] .= 2 .* u[1, 2:end]
            u_next[2, 2:end] .= u[2, 2:end] ./ 2
        else
            u_next[1, 2:end] .= - 2 .* u[1, 2:end]
            u_next[2, 2:end] .= - u[2, 2:end] ./ 2
        end
    end
    LEDemo(DiscreteExample(
        "Baker's map",
        phase_dynamics!, u0, tspan, nothing,
        tangent_dynamics!,
        num_attr,
        log.([2.0, 0.5]),       # known_exponents
        atol, rtol,
    ); kwargs...)
end

end
