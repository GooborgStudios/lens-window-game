local Actor = require('nx/game/actor')
local Scene = {}

function Scene.new(width,height)
    local self = newObject(Scene)
    self.hasStarted = false
    self.actors = {}
    self.originalActors = {}
    self.width = width
    self.height = height
    return self
end

function Scene:update(dt)
    for i,actor in ipairs(self.actors) do
        actor:sceneUpdate(dt)
    end
end

function Scene:draw(x,y)
    for i,actor in ipairs(self.actors) do
        actor:draw()
    end
end

-- Add actor to list
function Scene:addActor(actor, ...)
    assert(actor ~= nil,"Scene:addActor must take at least one argument")
    assert(actor.type == Actor,"Can't add a non-actor to a scene")

    actor.scene = self
    if actor.originalScene == nil then
        actor.originalScene = self
        append(self.originalActors,actor)
    end

    append(self.actors,actor)

    if ... then
        for i,v in ipairs({...}) do
            self:addActor(v)
        end
    end
end

-- Get actor by name
function Scene:getActor(actorName)
    assert(actorName)
    for i,actor in ipairs(self.actors) do
        if actor.name == actorName then
            return actor,i
        end
    end

    return nil
end

-- Get index of actor in actor list
function Scene:getActorIndex(actor)
    assert(actor)
    for i,iactor in ipairs(self.actors) do
        if iactor == actor then
            return i
        end
    end

    return nil
end

function Scene:getAllActors()
    return copyList(self.actors)
end

return Scene