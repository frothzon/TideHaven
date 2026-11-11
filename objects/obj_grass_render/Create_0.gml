/// @description setup


time = 0;

grass_gen = create_grass_generator();
grass_tileset = create_tile_generator(spr_grass_auto);
dirt_tileset = create_tile_generator(spr_ground_auto);

// add grass
tilemap_add_grass("GroundBase", grass_gen);
tilemap_add_grass("GroundAbove", grass_gen);

// add auto tile -- grass
tilemap_add_auto_tile("GroundBase", grass_tileset, 1);
tilemap_add_auto_tile("GroundAbove", grass_tileset, 1);
// add auto tile -- dirt
tilemap_add_auto_tile("GroundBase", dirt_tileset, 5, 10);
tilemap_add_auto_tile("GroundAbove", dirt_tileset, 5, 10);



// finish up building buffers
grass_gen.end_builder();
grass_tileset.end_builder();
dirt_tileset.end_builder();

// put all tilesets in an array
tileset_array = [grass_tileset, dirt_tileset];
