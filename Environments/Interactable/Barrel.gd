extends RigidBody2D

var hp = Globals.BARREL_HP
var destroyed : bool = false
var hits = []
onready var explosion_animation = get_node("Explosion")
onready var blast = get_node("BlastRadius")


func _ready():
	var player = get_parent().get_node("Player")
	var rifle_beam = player.get_node("RifleBeam")
	
	rifle_beam.connect("_on_hit_by_rifle", self, "_on_hit_by_rifle")

func _on_hit_by_rifle(object):
	# check if instance being collided
	# with is self
	if object == self:
		hp -= Globals.RIFLE_DMG

func _physics_process(_delta):
	if hp <= 0:
		destroy()
		destroyed = true


func destroy():
	self.rotation = 0
	if not destroyed:
		# show & play explosion animation
		explosion_animation.visible = true
		explosion_animation.play()
	if explosion_animation.animation == "ExplosionBig":
		# on frame 6 - expanding blast
		# apply impulse to all rigidbodies in
		# blast radius
		if explosion_animation.frame == 6:
			blastwave()
		# on last frame of animation destroy the object
		if explosion_animation.frame == explosion_animation.frames.get_frame_count("ExplosionBig")-1:
			queue_free()

func blastwave():
	# get all bodies within blast radius
	var objects_hit = blast.get_overlapping_bodies()
	# loop all colliders
	for obj in objects_hit:
		if obj.get_class() == "RigidBody2D":
			# apply kinematic impulse
			# to all rigidbodies in radius
			obj.apply_impulse(Vector2.ZERO, Vector2(-position.x * 0.1, -position.y * 0.1 ))
			if "hp" in obj:
				obj.hp -= 100
		elif obj.get_name() == "Player":
			# apply kinematic impulse
			# to all rigidbodies in radius
			obj.velocity = Vector2((obj.position.x - position.x) * 10, -10)
			if not obj in hits:
				hurt_body(obj)
		elif obj.is_in_group("enemies"):
			# apply kinematic impulse
			# to all rigidbodies in radius

			# apply knockback if object is mobile
			if "velocity" in obj:
				obj.velocity = Vector2((obj.position.x - position.x) * 10, -10)
			
			# apply damage to objects in blast zone
			if not obj in hits:
				hurt_body(obj)
		
func hurt_body(body):
	# calculate distance between explosion center and object
	var dist = body.transform.origin.distance_to(self.transform.origin)
	
	# if object is destructible,
	# apply damage based on distance
	if "hp" in body:
		var dmg = (100 - round(dist))
		body.hp -= dmg
		hits.append(body)
