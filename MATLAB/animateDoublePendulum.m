function [] = animateDoublePendulum(time, base_x, base_y, thA, thB, lA, lB, step)
    base_width = 2/5 * lA;
    base_height = lA/10;
    radius_bob1 = lA/6;
    radius_bob2 = lB/6;

    persistent tether1 base1 bob1 tether2 bob2
    hold on

    x_bobA = base_x + lA * sin(thA); %should be same as x_bobA
    y_bobA = base_y - lA * cos(thA); %should be same as y_bobA
    x_bobB = x_bobA + lB * sin(thB);
    y_bobB = y_bobA - lB * cos(thB);


    [tether2, bob2] = plotBottomPendulum(x_bobA(1), y_bobA(1), x_bobB(1), y_bobB(1), radius_bob2);
    [tether1, base1, bob1] = plotTopPendulum(base_x, base_y, x_bobA(1), y_bobA(1), ...
                                   base_width, base_height, radius_bob1);
    updateWindow(base_x, base_y, lA + lB, radius_bob2)

    for i = 2:length(time)
        tether2 = updateTether(tether2, x_bobA(i), y_bobA(i), x_bobB(i), y_bobB(i));
        bob2 = updateBob(bob2, x_bobB(i), y_bobB(i), radius_bob2);
        tether1 = updateTether(tether1, base_x, base_y, x_bobA(i), y_bobA(i));
        base1 = updateBase(base1, base_x, base_y, base_width, base_height);
        bob1 = updateBob(bob1, x_bobA(i), y_bobA(i), radius_bob1);

        drawnow
        pause(step);
    end
end

function [tether, base, bob] = plotTopPendulum(x_base, y_base, x_bob, y_bob, ...
                                            base_width, base_height, radius_bob)
    % Tether
    tether = plot([x_base, x_bob], [y_base, y_bob], 'k-', 'LineWidth', 2);

    % Base
    base_pos = [x_base - base_width/2, y_base - base_height/2, base_width, base_height];
    base = rectangle('Position', base_pos, 'FaceColor', 'k');

    % Bob
    pend_pos = [x_bob - radius_bob/2, y_bob - radius_bob/2, radius_bob, radius_bob];
    bob = rectangle('Position', pend_pos, 'Curvature', [1,1], 'FaceColor', 'g');
end

function [tether, bob] = plotBottomPendulum(x_base, y_base, x_bob, y_bob, radius_bob)
    % Tether
    tether = plot([x_base, x_bob], [y_base, y_bob], 'k-', 'LineWidth', 2);

    % Bob
    pend_pos = [x_bob - radius_bob/2, y_bob - radius_bob/2, radius_bob, radius_bob];
    bob = rectangle('Position', pend_pos, 'Curvature', [1,1], 'FaceColor', 'g');
end

function [] = updateWindow(x, y, r, radius_bob)
    gap = r/16;
    max_x = max(x) + r + radius_bob + gap;
    min_x = min(x) - r - radius_bob - gap;
    max_y = max(y) + r + radius_bob + gap;
    min_y = min(y) - r - radius_bob - gap;
    axis('equal')
    axis([min_x, max_x, min_y, max_y])
end

function [tether] = updateTether(tether, x_base, y_base, x_bob, y_bob)
    tether.XData = [x_base, x_bob];
    tether.YData = [y_base, y_bob];
end

function [base] = updateBase(base, x_base, y_base, base_width, base_height)
    base_pos = [x_base - base_width/2, y_base - base_height/2, base_width, base_height];
    base.Position = base_pos;
end

function [bob] = updateBob(bob, x_bob, y_bob, radius_bob)
    pend_pos = [x_bob - radius_bob/2, y_bob - radius_bob/2, radius_bob, radius_bob];
    bob.Position = pend_pos;
end