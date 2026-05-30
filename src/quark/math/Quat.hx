package quark.math;

@:forward
abstract Quat(BaseQuat) from BaseQuat to BaseQuat {

    public inline function new(x:Float, y:Float, z:Float, w:Float) {
        this = { x: x, y: y, z: z, w: w };
    }

    public static inline function identity():Quat
        return new Quat(0, 0, 0, 1);

    public static inline function fromAxisAngle(axis:Vec3, angle:Float):Quat {
        var half:Float = angle * 0.5;
        var s:Float = Math.sin(half);
        return new Quat(axis.x*s, axis.y*s, axis.z*s, Math.cos(half));
    }

    public static function fromEuler(x:Float, y:Float, z:Float):Quat {
        var cx:Float = Math.cos(x*0.5), sx:Float = Math.sin(x*0.5);
        var cy:Float = Math.cos(y*0.5), sy:Float = Math.sin(y*0.5);
        var cz:Float = Math.cos(z*0.5), sz:Float = Math.sin(z*0.5);
        return new Quat(
            sx*cy*cz + cx*sy*sz,
            cx*sy*cz - sx*cy*sz,
            cx*cy*sz + sx*sy*cz,
            cx*cy*cz - sx*sy*sz
        );
    }

    public static function fromMat3(m:Mat3):Quat {
        var d:Array<Float> = m.data;
        var m00:Float = d[0], m11:Float = d[4], m22:Float = d[8];
        var trace:Float = m00 + m11 + m22;
        var x:Float, y:Float, z:Float, w:Float;
        if (trace > 0) {
            var s:Float = 0.5 / Math.sqrt(trace + 1.0);
            w = 0.25 / s;
            x = (d[5] - d[7]) * s;
            y = (d[6] - d[2]) * s;
            z = (d[1] - d[3]) * s;
        } else if (m00 > m11 && m00 > m22) {
            var s:Float = 2.0 * Math.sqrt(1.0 + m00 - m11 - m22);
            w = (d[5] - d[7]) / s;
            x = 0.25 * s;
            y = (d[3] + d[1]) / s;
            z = (d[6] + d[2]) / s;
        } else if (m11 > m22) {
            var s:Float = 2.0 * Math.sqrt(1.0 + m11 - m00 - m22);
            w = (d[6] - d[2]) / s;
            x = (d[3] + d[1]) / s;
            y = 0.25 * s;
            z = (d[7] + d[5]) / s;
        } else {
            var s:Float = 2.0 * Math.sqrt(1.0 + m22 - m00 - m11);
            w = (d[1] - d[3]) / s;
            x = (d[6] + d[2]) / s;
            y = (d[7] + d[5]) / s;
            z = 0.25 * s;
        }
        return new Quat(x, y, z, w);
    }

    public static inline function fromMat4(m:Mat4):Quat
        return Quat.fromMat3(Mat3.fromMat4(m));

    public static function fromTo(from:Vec3, to:Vec3):Quat {
        var d:Float = from.dot(to);
        if (d >= 1.0 - 1e-6) return Quat.identity();
        if (d <= -1.0 + 1e-6) {
            var perp:Vec3 = MathUtils.perpendicular(from);
            return Quat.fromAxisAngle(perp, Math.PI);
        }
        var axis:Vec3 = from.cross(to);
        return new Quat(axis.x, axis.y, axis.z, 1.0 + d).normalized;
    }

    public var magnitude(get, never):Float;
    public var normalized(get, never):Quat;
    public var angle(get, never):Float;
    public var axis(get, never):Vec3;

    inline function get_magnitude():Float
        return Math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z + this.w*this.w);

    inline function get_normalized():Quat {
        var len:Float = magnitude;
        if (len < 1e-10) return identity();
        var inv:Float = 1.0 / len;
        return new Quat(this.x*inv, this.y*inv, this.z*inv, this.w*inv);
    }

    inline function get_angle():Float
        return 2.0 * Math.acos(MathUtils.clamp(this.w, -1, 1));

    inline function get_axis():Vec3 {
        var s2:Float = 1.0 - this.w*this.w;
        if (s2 < 1e-10) return new Vec3(1, 0, 0);
        var inv:Float = 1.0 / Math.sqrt(s2);
        return new Vec3(this.x*inv, this.y*inv, this.z*inv);
    }

    public inline function setFromMat3(m:Mat3):Void {
        var q:Quat = Quat.fromMat3(m);
        this.x = q.x; this.y = q.y; this.z = q.z; this.w = q.w;
    }

    @:op(A * B) public inline function multiply(b:Quat):Quat
        return new Quat(
            this.w*b.x + this.x*b.w + this.y*b.z - this.z*b.y,
            this.w*b.y - this.x*b.z + this.y*b.w + this.z*b.x,
            this.w*b.z + this.x*b.y - this.y*b.x + this.z*b.w,
            this.w*b.w - this.x*b.x - this.y*b.y - this.z*b.z
        );

    @:op(A * B) public inline function multiplyScalar(s:Float):Quat
        return new Quat(this.x*s, this.y*s, this.z*s, this.w*s);

    @:op(A * B) public inline function transformVec3(v:Vec3):Vec3 {
        var ix:Float = this.w*v.x + this.y*v.z - this.z*v.y;
        var iy:Float = this.w*v.y + this.z*v.x - this.x*v.z;
        var iz:Float = this.w*v.z + this.x*v.y - this.y*v.x;
        var iw:Float = -this.x*v.x - this.y*v.y - this.z*v.z;
        return new Vec3(
            ix*this.w + iw*(-this.x) + iy*(-this.z) - iz*(-this.y),
            iy*this.w + iw*(-this.y) + iz*(-this.x) - ix*(-this.z),
            iz*this.w + iw*(-this.z) + ix*(-this.y) - iy*(-this.x)
        );
    }

    @:op(A + B) public inline function add(b:Quat):Quat
        return new Quat(this.x+b.x, this.y+b.y, this.z+b.z, this.w+b.w);

    @:op(-A) public inline function negate():Quat
        return new Quat(-this.x, -this.y, -this.z, -this.w);

    @:op(A == B) public inline function equals(b:Quat):Bool
        return this.x == b.x && this.y == b.y && this.z == b.z && this.w == b.w;

    public inline function approximately(b:Quat, eps:Float = 1e-6):Bool
        return Math.abs(this.x-b.x) <= eps && Math.abs(this.y-b.y) <= eps
            && Math.abs(this.z-b.z) <= eps && Math.abs(this.w-b.w) <= eps;

    public inline function dot(b:Quat):Float
        return this.x*b.x + this.y*b.y + this.z*b.z + this.w*b.w;

    public inline function conjugate():Quat
        return new Quat(-this.x, -this.y, -this.z, this.w);

    public inline function inverse():Quat {
        var lenSq:Float = this.x*this.x + this.y*this.y + this.z*this.z + this.w*this.w;
        if (lenSq < 1e-10) return identity();
        var inv:Float = 1.0 / lenSq;
        return new Quat(-this.x*inv, -this.y*inv, -this.z*inv, this.w*inv);
    }

    public inline function lerp(to:Quat, t:Float):Quat
        return new Quat(
            this.x + (to.x-this.x)*t,
            this.y + (to.y-this.y)*t,
            this.z + (to.z-this.z)*t,
            this.w + (to.w-this.w)*t
        ).normalized;

    public static function slerp(a:Quat, b:Quat, t:Float):Quat {
        var dot:Float = a.dot(b);
        var bx:Float = b.x, by:Float = b.y, bz:Float = b.z, bw:Float = b.w;
        if (dot < 0) { dot = -dot; bx = -bx; by = -by; bz = -bz; bw = -bw; }
        if (dot > 0.9995) return a.lerp(new Quat(bx, by, bz, bw), t);
        var angle:Float = Math.acos(dot);
        var sinA:Float  = Math.sin((1-t) * angle);
        var sinB:Float  = Math.sin(t * angle);
        var sinT:Float  = Math.sin(angle);
        return new Quat(
            (a.x*sinA + bx*sinB) / sinT,
            (a.y*sinA + by*sinB) / sinT,
            (a.z*sinA + bz*sinB) / sinT,
            (a.w*sinA + bw*sinB) / sinT
        );
    }

    public static inline function angleBetween(a:Quat, b:Quat):Float {
        var d:Float = MathUtils.clamp(Math.abs(a.dot(b)), 0, 1);
        return Math.acos(2*d*d - 1);
    }

    public static function rotateToward(from:Quat, to:Quat, maxAngle:Float):Quat {
        var angle:Float = angleBetween(from, to);
        if (angle < 1e-6) return to;
        return slerp(from, to, Math.min(1, maxAngle / angle));
    }

    public static function squad(q0:Quat, q1:Quat, q2:Quat, q3:Quat, t:Float):Quat {
        var s1:Quat = squadInner(q0, q1, q2);
        var s2:Quat = squadInner(q1, q2, q3);
        return slerp(slerp(q1, q2, t), slerp(s1, s2, t), 2*t*(1-t));
    }

    static inline function squadInner(q0:Quat, q1:Quat, q2:Quat):Quat {
        var inv:Quat = q1.inverse();
        var a:Quat   = (inv * q0).log();
        var b:Quat   = (inv * q2).log();
        return (q1 * ((a + b).multiplyScalar(-0.25)).exp()).normalized;
    }

    public inline function exp():Quat {
        var v:Float = Math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z);
        var sinV:Float = v < 1e-10 ? 1.0 : Math.sin(v) / v;
        return new Quat(this.x*sinV, this.y*sinV, this.z*sinV, Math.cos(v));
    }

    public inline function log():Quat {
        var v:Float  = Math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z);
        var scale:Float = v < 1e-10 ? 1.0 : Math.atan2(v, this.w) / v;
        return new Quat(this.x*scale, this.y*scale, this.z*scale, 0);
    }

    public inline function toEuler():Vec3 {
        var sinX:Float = 2*(this.w*this.x + this.y*this.z);
        var cosX:Float = 1 - 2*(this.x*this.x + this.y*this.y);
        var sinY:Float = 2*(this.w*this.y - this.z*this.x);
        var sinZ:Float = 2*(this.w*this.z + this.x*this.y);
        var cosZ:Float = 1 - 2*(this.y*this.y + this.z*this.z);
        return new Vec3(
            Math.atan2(sinX, cosX),
            Math.abs(sinY) >= 1 ? Math.PI/2 * MathUtils.sign(sinY) : Math.asin(sinY),
            Math.atan2(sinZ, cosZ)
        );
    }

    public inline function toMat3():Mat3 {
        var xx:Float = this.x*this.x, yy:Float = this.y*this.y, zz:Float = this.z*this.z;
        var xy:Float = this.x*this.y, xz:Float = this.x*this.z, yz:Float = this.y*this.z;
        var wx:Float = this.w*this.x, wy:Float = this.w*this.y, wz:Float = this.w*this.z;
        return new Mat3(
            1-2*(yy+zz),   2*(xy+wz),   2*(xz-wy),
              2*(xy-wz), 1-2*(xx+zz),   2*(yz+wx),
              2*(xz+wy),   2*(yz-wx), 1-2*(xx+yy)
        );
    }

    @:to public inline function toMat4():Mat4 {
        var xx:Float = this.x*this.x, yy:Float = this.y*this.y, zz:Float = this.z*this.z;
        var xy:Float = this.x*this.y, xz:Float = this.x*this.z, yz:Float = this.y*this.z;
        var wx:Float = this.w*this.x, wy:Float = this.w*this.y, wz:Float = this.w*this.z;
        return new Mat4(
            1-2*(yy+zz),   2*(xy+wz),   2*(xz-wy), 0,
              2*(xy-wz), 1-2*(xx+zz),   2*(yz+wx), 0,
              2*(xz+wy),   2*(yz-wx), 1-2*(xx+yy), 0,
            0,           0,           0,           1
        );
    }

    public inline function toString():String
        return 'Quat(${this.x}, ${this.y}, ${this.z}, ${this.w})';
}

@:structInit
private class BaseQuat {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var w:Float;
}