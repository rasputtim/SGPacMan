/*
  SGF - Salvat Game Fabric  (https://sourceforge.net/projects/sgfabric/)
  Copyright (C) 2010-2011 Salvatore Giannotta Filho <a_materasu@hotmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

  */

#ifndef __SGF_GUI_BOUNDS_H__
#define __SGF_GUI_BOUNDS_H__
#include "../ExternalLibs/smf/Gamecore/math/all.h"
#include "../ExternalLibs/smf/Gamecore/geometry/all.h"
/*
===============================================================================

	Axis Aligned Bounding Box

===============================================================================
*/
namespace SGF{
namespace Gui {
using namespace ::SMF::MATH;

class CBoundBox {
public:
					CBoundBox( void );
					explicit CBoundBox( const CVec3D &mins, const CVec3D &maxs );
					explicit CBoundBox( const CVec3D &point );

	const CVec3D &	operator[]( const int index ) const;
	CVec3D &		operator[]( const int index );
	CBoundBox		operator+( const CVec3D &t ) const;				// returns translated bounds
	CBoundBox &		operator+=( const CVec3D &t );					// translate the bounds
	CBoundBox		operator*( const CMat3D &r ) const;				// returns rotated bounds
	CBoundBox &		operator*=( const CMat3D &r );					// rotate the bounds
	CBoundBox		operator+( const CBoundBox &a ) const;
	CBoundBox &		operator+=( const CBoundBox &a );
	CBoundBox		operator-( const CBoundBox &a ) const;
	CBoundBox &		operator-=( const CBoundBox &a );

	bool			Compare( const CBoundBox &a ) const;							// exact compare, no epsilon
	bool			Compare( const CBoundBox &a, const float epsilon ) const;	// compare with epsilon
	bool			operator==(	const CBoundBox &a ) const;						// exact compare, no epsilon
	bool			operator!=(	const CBoundBox &a ) const;						// exact compare, no epsilon

	void			Clear( void );									// inside out bounds
	void			Zero( void );									// single point at origin

	CVec3D			GetCenter( void ) const;						// returns center of bounds
	float			GetRadius( void ) const;						// returns the radius relative to the bounds origin
	float			GetRadius( const CVec3D &center ) const;		// returns the radius relative to the given center
	float			GetVolume( void ) const;						// returns the volume of the bounds
	bool			IsCleared( void ) const;						// returns true if bounds are inside out

	bool			AddPoint( const CVec3D &v );					// add the point, returns true if the bounds expanded
	bool			AddBounds( const CBoundBox &a );					// add the bounds, returns true if the bounds expanded
	CBoundBox		Intersect( const CBoundBox &a ) const;			// return intersection of this bounds with the given bounds
	CBoundBox &		IntersectSelf( const CBoundBox &a );				// intersect this bounds with the given bounds
	CBoundBox		Expand( const float d ) const;					// return bounds expanded in all directions with the given value
	CBoundBox &		ExpandSelf( const float d );					// expand bounds in all directions with the given value
	CBoundBox		Translate( const CVec3D &translation ) const;	// return translated bounds
	CBoundBox &		TranslateSelf( const CVec3D &translation );		// translate this bounds
	CBoundBox		Rotate( const CMat3D &rotation ) const;			// return rotated bounds
	CBoundBox &		RotateSelf( const CMat3D &rotation );			// rotate this bounds

	float			PlaneDistance( const CPlane &plane ) const;
	int				PlaneSide( const CPlane &plane, const float epsilon = ON_EPSILON ) const;

	bool			ContainsPoint( const CVec3D &p ) const;			// includes touching
	bool			IntersectsBounds( const CBoundBox &a ) const;	// includes touching
	bool			LineIntersection( const CVec3D &start, const CVec3D &end ) const;
					// intersection point is start + dir * scale
	bool			RayIntersection( const CVec3D &start, const CVec3D &dir, float &scale ) const;

					// most tight bounds for the given transformed bounds
	void			FromTransformedBounds( const CBoundBox &bounds, const CVec3D &origin, const CMat3D &axis );
					// most tight bounds for a point set
	void			FromPoints( const CVec3D *points, const int numPoints );
					// most tight bounds for a translation
	void			FromPointTranslation( const CVec3D &point, const CVec3D &translation );
	void			FromBoundsTranslation( const CBoundBox &bounds, const CVec3D &origin, const CMat3D &axis, const CVec3D &translation );
					// most tight bounds for a rotation
	void			FromPointRotation( const CVec3D &point, const CRotation &rotation );
	void			FromBoundsRotation( const CBoundBox &bounds, const CVec3D &origin, const CMat3D &axis, const CRotation &rotation );

	void			ToPoints( CVec3D points[8] ) const;
	//idSphere		ToSphere( void ) const;

	void			AxisProjection( const CVec3D &dir, float &min, float &max ) const;
	void			AxisProjection( const CVec3D &origin, const CMat3D &axis, const CVec3D &dir, float &min, float &max ) const;

private:
	CVec3D			b[2];
};

extern CBoundBox	bounds_zero;

SGF_INLINE_FORCED CBoundBox::CBoundBox( void ) {
}

SGF_INLINE_FORCED CBoundBox::CBoundBox( const CVec3D &mins, const CVec3D &maxs ) {
	b[0] = mins;
	b[1] = maxs;
}

SGF_INLINE_FORCED CBoundBox::CBoundBox( const CVec3D &point ) {
	b[0] = point;
	b[1] = point;
}

SGF_INLINE_FORCED const CVec3D &CBoundBox::operator[]( const int index ) const {
	return b[index];
}

SGF_INLINE_FORCED CVec3D &CBoundBox::operator[]( const int index ) {
	return b[index];
}

SGF_INLINE_FORCED CBoundBox CBoundBox::operator+( const CVec3D &t ) const {
	return CBoundBox( b[0] + t, b[1] + t );
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::operator+=( const CVec3D &t ) {
	b[0] += t;
	b[1] += t;
	return *this;
}

SGF_INLINE_FORCED CBoundBox CBoundBox::operator*( const CMat3D &r ) const {
	CBoundBox bounds;
	bounds.FromTransformedBounds( *this, CVec3D::origin, r );
	return bounds;
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::operator*=( const CMat3D &r ) {
	this->FromTransformedBounds( *this, CVec3D::origin, r );
	return *this;
}

SGF_INLINE_FORCED CBoundBox CBoundBox::operator+( const CBoundBox &a ) const {
	CBoundBox newBounds;
	newBounds = *this;
	newBounds.AddBounds( a );
	return newBounds;
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::operator+=( const CBoundBox &a ) {
	CBoundBox::AddBounds( a );
	return *this;
}

SGF_INLINE_FORCED CBoundBox CBoundBox::operator-( const CBoundBox &a ) const {
	assert( b[1][0] - b[0][0] > a.b[1][0] - a.b[0][0] &&
				b[1][1] - b[0][1] > a.b[1][1] - a.b[0][1] &&
					b[1][2] - b[0][2] > a.b[1][2] - a.b[0][2] );
	return CBoundBox( CVec3D( b[0][0] + a.b[1][0], b[0][1] + a.b[1][1], b[0][2] + a.b[1][2] ),
					CVec3D( b[1][0] + a.b[0][0], b[1][1] + a.b[0][1], b[1][2] + a.b[0][2] ) );
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::operator-=( const CBoundBox &a ) {
	assert( b[1][0] - b[0][0] > a.b[1][0] - a.b[0][0] &&
				b[1][1] - b[0][1] > a.b[1][1] - a.b[0][1] &&
					b[1][2] - b[0][2] > a.b[1][2] - a.b[0][2] );
	b[0] += a.b[1];
	b[1] += a.b[0];
	return *this;
}

SGF_INLINE_FORCED bool CBoundBox::Compare( const CBoundBox &a ) const {
	return ( b[0].compare( a.b[0] ) && b[1].compare( a.b[1] ) );
}

SGF_INLINE_FORCED bool CBoundBox::Compare( const CBoundBox &a, const float epsilon ) const {
	return ( b[0].compare( a.b[0], epsilon ) && b[1].compare( a.b[1], epsilon ) );
}

SGF_INLINE_FORCED bool CBoundBox::operator==( const CBoundBox &a ) const {
	return Compare( a );
}

SGF_INLINE_FORCED bool CBoundBox::operator!=( const CBoundBox &a ) const {
	return !Compare( a );
}

SGF_INLINE_FORCED void CBoundBox::Clear( void ) {
	b[0][0] = b[0][1] = b[0][2] = CMath::INFINITY_FLOAT;
	b[1][0] = b[1][1] = b[1][2] = -CMath::INFINITY_FLOAT;
}

SGF_INLINE_FORCED void CBoundBox::Zero( void ) {
	b[0][0] = b[0][1] = b[0][2] =
	b[1][0] = b[1][1] = b[1][2] = 0;
}

SGF_INLINE_FORCED CVec3D CBoundBox::GetCenter( void ) const {
	return CVec3D( ( b[1][0] + b[0][0] ) * 0.5f, ( b[1][1] + b[0][1] ) * 0.5f, ( b[1][2] + b[0][2] ) * 0.5f );
}

SGF_INLINE_FORCED float CBoundBox::GetVolume( void ) const {
	if ( b[0][0] >= b[1][0] || b[0][1] >= b[1][1] || b[0][2] >= b[1][2] ) {
		return 0.0f;
	}
	return ( ( b[1][0] - b[0][0] ) * ( b[1][1] - b[0][1] ) * ( b[1][2] - b[0][2] ) );
}

SGF_INLINE_FORCED bool CBoundBox::IsCleared( void ) const {
	return b[0][0] > b[1][0];
}

SGF_INLINE_FORCED bool CBoundBox::AddPoint( const CVec3D &v ) {
	bool expanded = false;
	if ( v[0] < b[0][0]) {
		b[0][0] = v[0];
		expanded = true;
	}
	if ( v[0] > b[1][0]) {
		b[1][0] = v[0];
		expanded = true;
	}
	if ( v[1] < b[0][1] ) {
		b[0][1] = v[1];
		expanded = true;
	}
	if ( v[1] > b[1][1]) {
		b[1][1] = v[1];
		expanded = true;
	}
	if ( v[2] < b[0][2] ) {
		b[0][2] = v[2];
		expanded = true;
	}
	if ( v[2] > b[1][2]) {
		b[1][2] = v[2];
		expanded = true;
	}
	return expanded;
}

SGF_INLINE_FORCED bool CBoundBox::AddBounds( const CBoundBox &a ) {
	bool expanded = false;
	if ( a.b[0][0] < b[0][0] ) {
		b[0][0] = a.b[0][0];
		expanded = true;
	}
	if ( a.b[0][1] < b[0][1] ) {
		b[0][1] = a.b[0][1];
		expanded = true;
	}
	if ( a.b[0][2] < b[0][2] ) {
		b[0][2] = a.b[0][2];
		expanded = true;
	}
	if ( a.b[1][0] > b[1][0] ) {
		b[1][0] = a.b[1][0];
		expanded = true;
	}
	if ( a.b[1][1] > b[1][1] ) {
		b[1][1] = a.b[1][1];
		expanded = true;
	}
	if ( a.b[1][2] > b[1][2] ) {
		b[1][2] = a.b[1][2];
		expanded = true;
	}
	return expanded;
}

SGF_INLINE_FORCED CBoundBox CBoundBox::Intersect( const CBoundBox &a ) const {
	CBoundBox n;
	n.b[0][0] = ( a.b[0][0] > b[0][0] ) ? a.b[0][0] : b[0][0];
	n.b[0][1] = ( a.b[0][1] > b[0][1] ) ? a.b[0][1] : b[0][1];
	n.b[0][2] = ( a.b[0][2] > b[0][2] ) ? a.b[0][2] : b[0][2];
	n.b[1][0] = ( a.b[1][0] < b[1][0] ) ? a.b[1][0] : b[1][0];
	n.b[1][1] = ( a.b[1][1] < b[1][1] ) ? a.b[1][1] : b[1][1];
	n.b[1][2] = ( a.b[1][2] < b[1][2] ) ? a.b[1][2] : b[1][2];
	return n;
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::IntersectSelf( const CBoundBox &a ) {
	if ( a.b[0][0] > b[0][0] ) {
		b[0][0] = a.b[0][0];
	}
	if ( a.b[0][1] > b[0][1] ) {
		b[0][1] = a.b[0][1];
	}
	if ( a.b[0][2] > b[0][2] ) {
		b[0][2] = a.b[0][2];
	}
	if ( a.b[1][0] < b[1][0] ) {
		b[1][0] = a.b[1][0];
	}
	if ( a.b[1][1] < b[1][1] ) {
		b[1][1] = a.b[1][1];
	}
	if ( a.b[1][2] < b[1][2] ) {
		b[1][2] = a.b[1][2];
	}
	return *this;
}

SGF_INLINE_FORCED CBoundBox CBoundBox::Expand( const float d ) const {
	return CBoundBox( CVec3D( b[0][0] - d, b[0][1] - d, b[0][2] - d ),
						CVec3D( b[1][0] + d, b[1][1] + d, b[1][2] + d ) );
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::ExpandSelf( const float d ) {
	b[0][0] -= d;
	b[0][1] -= d;
	b[0][2] -= d;
	b[1][0] += d;
	b[1][1] += d;
	b[1][2] += d;
	return *this;
}

SGF_INLINE_FORCED CBoundBox CBoundBox::Translate( const CVec3D &translation ) const {
	return CBoundBox( b[0] + translation, b[1] + translation );
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::TranslateSelf( const CVec3D &translation ) {
	b[0] += translation;
	b[1] += translation;
	return *this;
}

SGF_INLINE_FORCED CBoundBox CBoundBox::Rotate( const CMat3D &rotation ) const {
	CBoundBox bounds;
	bounds.FromTransformedBounds( *this, CVec3D::origin, rotation );
	return bounds;
}

SGF_INLINE_FORCED CBoundBox &CBoundBox::RotateSelf( const CMat3D &rotation ) {
	FromTransformedBounds( *this, CVec3D::origin, rotation );
	return *this;
}

SGF_INLINE_FORCED bool CBoundBox::ContainsPoint( const CVec3D &p ) const {
	if ( p[0] < b[0][0] || p[1] < b[0][1] || p[2] < b[0][2]
		|| p[0] > b[1][0] || p[1] > b[1][1] || p[2] > b[1][2] ) {
		return false;
	}
	return true;
}

SGF_INLINE_FORCED bool CBoundBox::IntersectsBounds( const CBoundBox &a ) const {
	if ( a.b[1][0] < b[0][0] || a.b[1][1] < b[0][1] || a.b[1][2] < b[0][2]
		|| a.b[0][0] > b[1][0] || a.b[0][1] > b[1][1] || a.b[0][2] > b[1][2] ) {
		return false;
	}
	return true;
}
/*
SGF_INLINE_FORCED idSphere CBoundBox::ToSphere( void ) const {
	idSphere sphere;
	sphere.SetOrigin( ( b[0] + b[1] ) * 0.5f );
	sphere.SetRadius( ( b[1] - sphere.getOrigin() ).Length() );
	return sphere;
}
*/
SGF_INLINE_FORCED void CBoundBox::AxisProjection( const CVec3D &dir, float &min, float &max ) const {
	float d1, d2;
	CVec3D center, extents;

	center = ( b[0] + b[1] ) * 0.5f;
	extents = b[1] - center;

	d1 = dir * center;
	d2 = CMath::fabs( extents[0] * dir[0] ) +
			CMath::fabs( extents[1] * dir[1] ) +
				CMath::fabs( extents[2] * dir[2] );

	min = d1 - d2;
	max = d1 + d2;
}

SGF_INLINE_FORCED void CBoundBox::AxisProjection( const CVec3D &origin, const CMat3D &axis, const CVec3D &dir, float &min, float &max ) const {
	float d1, d2;
	CVec3D center, extents;

	center = ( b[0] + b[1] ) * 0.5f;
	extents = b[1] - center;
	center = origin + center * axis;

	d1 = dir * center;
	d2 = CMath::fabs( extents[0] * ( dir * axis[0] ) ) +
			CMath::fabs( extents[1] * ( dir * axis[1] ) ) +
				CMath::fabs( extents[2] * ( dir * axis[2] ) );

	min = d1 - d2;
	max = d1 + d2;
}
} //end Gui
} //end SGF
#endif /* !__SGF_GUI_BOUNDS_H__ */
