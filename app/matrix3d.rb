module Engine3D
  class Matrix
    def initialize(coefficients)
      @coefficients = coefficients
    end

    def self.identity()
      Matrix.new([[1.0,0.0,0.0,0.0],
                  [0.0,1.0,0.0,0.0],
                  [0.0,0.0,1.0,0.0],
                  [0.0,0.0,0.0,1.0]])
    end

    def [](i,j)    @coefficients[i][j]     end
    def []=(i,j,v) @coefficients[i][j] = v end

    def +(other)
      sum_matrix = []
      4.times do |i|
        sum_row = []
        4.times do |j|
          sum_row << self[i,j] + other[i,j]
        end
        sum_matrix << sum_row
      end

      Matrix.new(sum_matrix)
    end

    def *(other)
      case
      when other.is_a?(Engine3D::Vector) then mul_vect(other)
      when other.is_a?(Engine3D::Matrix) then mul_mat(other)
      end 
    end

    private
    def mul_mat(other)
      mul_coefficients = []
      4.times do |i|
        mul_row = []
        4.times do |j|
          mul_result = 0.0
          4.times do |s|
            mul_result += self[i,s] * other[s,j]
          end
          mul_row << mul_result
        end
        mul_coefficients << mul_row
      end

      Matrix.new(mul_coefficients)
    end

    def mul_vect(other)
      mul_coefficients = []
      4.times do |i|
        mul_result = 0.0
        4.times do |s|
          mul_result += self[i,s] * other[s]
        end
        mul_coefficients << mul_result
      end

      Vector.new(*mul_coefficients)
    end

    public
    def mul_vect_3d(other)
      Vector.new( @coefficients[0][0]*other[0] + @coefficients[0][1]*other[1] + @coefficients[0][2]*other[2] + @coefficients[0][3],
                  @coefficients[1][0]*other[0] + @coefficients[1][1]*other[1] + @coefficients[1][2]*other[2] + @coefficients[1][3],
                  @coefficients[2][0]*other[0] + @coefficients[2][1]*other[1] + @coefficients[2][2]*other[2] + @coefficients[2][3],
                  1.0 )
    end

    def ==(other)
      equality = true
      4.times do |i|
        4.times do |j|
          equality = false if ( self[i,j] - other[i,j] ).abs >= Engine3D::PRECISION
        end
      end

      equality
    end

    def to_s()
      s  = "[[#{self[0,0]},#{self[0,1]},#{self[0,2]},#{self[0,3]}],\n"
      s += " [#{self[1,0]},#{self[1,1]},#{self[1,2]},#{self[1,3]}],\n"
      s += " [#{self[2,0]},#{self[2,1]},#{self[2,2]},#{self[2,3]}],\n"
      s += " [#{self[3,0]},#{self[3,1]},#{self[3,2]},#{self[3,3]}]]"
      s
    end
  end
end
