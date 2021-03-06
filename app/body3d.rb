module Engine3D
  class Body
    attr_accessor :world_matrix,
                  :vertices

    def initialize(&setup_block)
      @world_matrix = Engine3D::Matrix.identity
      @vertices     = []

      instance_eval &setup_block
    end 

    def self.load(filepath)
      body_description = nil
      #File.open(filepath, 'r') { |f| body_description = f.read }
      f=File.open(filepath, 'r')
      body_description = f.read
      f.close

      instance_eval body_description
    end

    def add_vertex(vertex)
      @vertices << vertex
    end

    def x() @world_matrix[0,3] end
    def y() @world_matrix[1,3] end
    def z() @world_matrix[2,3] end

    def move_to(x,y,z)
      @world_matrix[0,3] = x
      @world_matrix[1,3] = y
      @world_matrix[2,3] = z
    end

    def translate(dx,dy,dz)
      @world_matrix[0,3] += dx
      @world_matrix[1,3] += dy
      @world_matrix[2,3] += dz
    end

    def rotate_x(angle)
      rot_matrix        = Matrix.identity

      rot_matrix[1,1]   =  Math.cos(angle)
      rot_matrix[1,2]   = -Math.sin(angle)
      rot_matrix[2,1]   =  Math.sin(angle)
      rot_matrix[2,2]   =  Math.cos(angle)

      @world_matrix    *= rot_matrix
    end

    def rotate_y(angle)
      rot_matrix	= Matrix.identity

      rot_matrix[0,0]   =  Math.cos(angle)
      rot_matrix[0,2]   =  Math.sin(angle)
      rot_matrix[2,0]   = -Math.sin(angle)
      rot_matrix[2,2]   =  Math.cos(angle)

      @world_matrix    *= rot_matrix
    end

    def rotate_z(angle)
      rot_matrix	= Matrix.identity

      rot_matrix[0,0]   =  Math.cos(angle)
      rot_matrix[0,1]   = -Math.sin(angle)
      rot_matrix[1,0]   =  Math.sin(angle)
      rot_matrix[1,1]   =  Math.cos(angle)

      @world_matrix    *= rot_matrix
    end

    def rotate(rotations)
      rotations.each_pair { |axis,angle| self.send("rotate_#{axis}".to_sym,angle) }
    end

    def clear_rotation
      @world_matrix[0,0]  = 1.0
      @world_matrix[0,1]  = 0.0
      @world_matrix[0,2]  = 0.0
      @world_matrix[1,0]  = 0.0
      @world_matrix[1,1]  = 1.0
      @world_matrix[1,2]  = 0.0
      @world_matrix[2,0]  = 0.0
      @world_matrix[2,1]  = 0.0
      @world_matrix[2,2]  = 1.0
      @world_matrix[3,3]  = 1.0
    end

    def rotate_absolute(rotations)
      clear_rotation
      rotate rotations
    end

    def inspect
      s= "- body #{object_id}:\n"
      @vertices.each.with_index { |v,i| s << "-- vertex #{i}:\n#{v.inspect}\n" }
      s
    end
  end
end
