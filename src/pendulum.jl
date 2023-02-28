using Printf
using GLMakie

"""
    pendulum_run(;fps=60)

Run a pendulum simulation at the given framerate.
"""
function pendulum_run(;fps=60)
    m = 3
    l = 1
    g = 9.81
    b = 0.1

    fig = Figure()
    ax = Axis(fig[1, 1], aspect=1)
    limits!(ax, [-1.5, 1.5], [-1.5, 1.5])

    x = Observable([π - 0.1, 0.0])
    u = Observable(0.0)
    sl = Slider(fig[2, 1], range=-1:0.01:1, startvalue=0, tellwidth=false)
    w = @lift(-10 * $(sl.value))

    θ = draw_pendulum!(ax, x, u, w, m*l*g)
    fig[1, 2] = Legend(fig, ax, valign=:top)

    sg = SliderGrid(fig[1, 2],
                    (label = "Max Torque", range = 0:5:30, format = "{} Nm", startvalue = 10),
                    (label = "Derivative", range = 0:5:20, startvalue = 15),
                    (label = "Control Rate", range = 1:20, format = "{}/60 s", startvalue=6),
                    width=300,
                    tellheight=false
    )
    τ_max = sg.sliders[1].value
    K_D = sg.sliders[2].value
    delay = sg.sliders[3].value

    #K = [-0.0941782  3.19134]
    K = @lift([57  $K_D])

    on(events(fig.scene).window_open) do event
        event || return
        frame = 0
        @async while isopen(fig.scene)
            if frame % delay[] == 0
                xround = [rem(x[][1], 2π, RoundDown) - π, x[][2]]
                u[] = clamp((K[] * xround)[1], -τ_max[], τ_max[])
            end

            dx = [x[][2];
                  (w[] - u[] - m * g * l * sin(x[][1]) - b * x[][2] ) / (m * l^2)]
            x[] = x[] + dx * 1/fps

            sleep(1/fps)
            frame += 1
        end
    end

    on(events(fig.scene).joystickaxes[2]) do event
        if event !== nothing
            set_close_to!(sl, event[1])
        end
    end

    fig
end

"""
    draw_pendulum!(ax::Axis)

Draw a unit length pendulum on the given axis.  Returns θ, the angle of the pendulum from
vertical.
"""
function draw_pendulum!(ax::Axis, x, u, w, grav)
    θ = @lift($x[1])
    pend = @lift(Point2f(sin($θ), -cos($θ)))
    points = @lift([Point2f(0, 0), $pend])

    # Pendulum
    lines!(ax, points)
    scatter!(ax, pend, marker=:circle, markersize=0.2, markerspace=:data)

    # Forces
    arrow_root = @lift([$pend])
    arrow_scale = 0.03
    # Gravity
    arrows!(ax, arrow_root, [Point2f(0, -grav*arrow_scale)], label="Gravity", color=:orange)
    # Torque from controller
    arrows!(ax, arrow_root, @lift([Point2f(-cos($θ) * arrow_scale*$u, -sin($θ) * arrow_scale*$u)]), label="Controller torque", color=:green)
    # Torque from disturbance
    arrows!(ax, arrow_root, @lift([Point2f(cos($θ) * arrow_scale*$w, sin($θ) * arrow_scale*$w)]), label="Disturbance torque", color=:purple)

    θ
end
