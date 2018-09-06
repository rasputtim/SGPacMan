#ifndef __SMF_CIRCLE_
#define __SMF_CIRCLE_

#include "../SMF_Config.h"
#include "../math/all.h"
#include "all.h"

namespace SMF {
using namespace MATH;
using namespace Util;
namespace GEO{





/**
 * \class CCircle
 *
 * \ingroup SMF_Geometric
 * \image html pics/circle.png
 * \if pt_br
 * \brief   Um C�rculo bidimensional em espa�o 3D
 * \note Armazena os tr�s pontos v�rtices a,b,c que definem um tri�ngulo 
 * \elseif us_en
 * \brief 	A two-dimensional circle in 3D space.
   \note This class represents both a hollow circle (only edge) and a solid circle (disc).
 * \endif
 * \author (last to touch it) $Autor: Salvathor $
 *
 * \version 1.0 $Revision: 1.0 $
 *
 * Contact: carygrant@ig.com.br
 *
 */
class SMF_API CCircle
{
public:
	/// The center position of this circle.
	CVec3D pos;

	/// The normal direction of this circle. [similarOverload: pos]
	/** A circle is a two-dimensional object in 3D space. This normal vector (together with the pos member)
		specifies the plane in which this circle lies in.
		This vector is always normalized. If you assign to this member directly, be sure to only assign normalized vectors. */
	CVec3D normal;

	/// The radius of the circle. [similarOverload: pos]
	/** This parameter must be strictly positive to specify a non-degenerate circle. If zero is specified, this circle
		is considered to be degenerate.
		\see CCircle::CCircle(). */
	float r;

	/// The default constructor does not initialize any members of this class.
	/** This means that the values of the members pos, normal and r are all undefined after creating a new circle using
		this default constructor. Remember to assign to them before use.
		\see pos, normal, r. */
	CCircle() {}

	/// Constructs a new circle by explicitly specifying the member variables.
	/** \param center The center point of the circle.
		\param normal The direction vector that specifies the orientation of this circle. This vector must be normalized,
			this constructor will not normalize the vector for you (for performance reasons).
		\param radius The radius of the circle.
		\see pos, normal, r. */
	CCircle(const CVec3D &center, const CVec3D &normal, float radius);

	/// Returns a normalized direction vector to the 'U direction' of the circle.
	/** This vector lies on the plane of this circle.
		The U direction specifies the first basis vector of a local space of this circle. */
	CVec3D basisU() const;

	/// Returns a normalized direction vector to the 'V direction' of the circle.
	/** This vector lies on the plane of this circle.
		The U direction specifies the second basis vector of a local space of this circle. */
	CVec3D basisV() const;

	/// Returns a point at the edge of this circle.
	/** \param angleRadians The direction of the point to get. A full circle is generated by the range [0, 2*pi],
			but it is ok to pass in values outside this range.
		\note This function is equivalent to calling getPoint(float angleRadians, float d) with a value of d == 1.
		\return A point in world space at the edge of this circle. */
	CVec3D getPoint(float angleRadians) const;

	/// Returns a point inside this circle.
	/** \param angleRadians The direction of the point to get. A full circle is generated by the range [0, 2*pi],
			but it is ok to pass in values outside this range.
		\param d A value in the range [0,1] that specifies the normalzied distance of the point from the center of the circle.
			A value of 0 returns the center point of this circle. A value of 1 returns a point at the edge of this circle.
			The range of d is not restricted, so it is ok to pass in values larger than 1 to generate a point lying completely
			outside this circle. */
	CVec3D getPoint(float angleRadians, float d) const;

	/// Returns the center point of this circle.
	/** This point is also the center of mass for this circle. The functions centerPoint() and centroid() are equivalent.
		\see pos. */
	CVec3D centerPoint() const { return pos; }
	CVec3D centroid() const { return pos; } ///< [similarOverload: centerPoint]
	/** 
	\if pt_br
	\brief Testa se o circulo � \b finito \b
	\note A esfera � \b finito \b se seus membros origin e radius n�o possuem NaNs (not a number http://en.wikipedia.org/wiki/NaN) ou n�meros infinitos +/-. \n
	\elseif us_en
	\brief Tests if this Circle is finite.
	\note A circle is \b finite \b if its members origin and radius do not contain floating-point NaNs or +/-infs
		in them.
	\return True if the members pos and r both have finite floating-point values.
	\endif
	\see origin, radius, isDegenerate(), isFinite(), isInf(), IsNan(), isFinite(), CMath::INFINITE_FLOAT, CMath::NEG_INFINITE_FLOAT, CMath::NAN_FLOAT, CVec3D::nan, CVec3D::infinity. */
	bool isFinite() const;

	/** 
	\if pt_br
	\brief Retorna verdaddeiro se o circulo � \b degenerado \b.
	\note Um esfera � degenerada se ela n�o for finita, ou se seu raio for menor ou igual a zero \n
	\elseif us_en
	\brief Returns true if this Circle is \b degenerate \b.
	\note A Circle is \b degenerate \b if it is not finite, or if the radius of the circle is less or equal to 0. \p
	\endif
	\see origin, radius, isFinite() 
	**/
	bool isDegenerate() const;
	/// Computes an extreme point of this CCircle/Disc in the given direction.
	/** An extreme point is a farthest point of this CCircle/Disc in the given direction. Given a direction,
		this point is not necessarily unique.
		\param direction The direction vector of the direction to find the extreme point. This vector may
			be unnormalized, but may not be null.
		\return An extreme point of this CCircle/Disc in the given direction. The returned point is always at
			the edge of this CCircle. */
	CVec3D extremePoint(const CVec3D &direction) const;

	/// Computes the plane this circle is contained in.
	/** All the points of this circle lie inside this plane.
		\see class CPlane. */
	CPlane containingPlane() const;

	/// Translates this CCircle in world space.
	/** \param offset The amount of displacement to apply to this CCircle, in world space coordinates.
		\see transform(). */
	void translate(const CVec3D &offset);

	/// Applies a transformation to this CCircle.
	/** \param transform The transformation to apply to this CCircle. This transformation must be
		affine, and must contain an orthogonal set of column vectors (may not contain shear or projection).
		The transformation can only contain uniform scale, and may not contain mirroring.
		\see translate(), scale(), classes CMat3D, CMatJoint3x4, CMat4D, CQuaternion. */
	void transform(const CMat3D &transform);
	void transform(const CMatJoint3x4 &transform);
	void transform(const CMat4D &transform);
	void transform(const CQuaternion &transform);

	/// Tests if the given point is contained at the edge of this circle.
	/** \param point The target point to test.
		\param maxDistance The epsilon threshold to test the distance against. This effectively turns the circle into a torus
			for this test.
		\see distanceToEdge(), distanceToDisc(), closestPointToEdge(), closestPointToDisc().
		\todo Implement DiscContains(CVec3D/CLineSegment/CTriangle). */
	bool edgeContains(const CVec3D &point, float maxDistance = 1e-6f) const;

	// Returns true if the given point lies inside this filled circle.
	// \param maxDistance The epsilon threshold to test the distance against.
//	bool DiscContains(const CVec3D &point, float maxDistance = 1e-6f) const;
//	bool DiscContains(const CLineSegment &lineSegment, float maxDistance = 1e-6f) const;

	/// Computes the distance of the given object to the edge of this circle.
	/** \todo Implement distanceToEdge(CRay/CLineSegment/CLine).
		\return The distance of the given point to the edge of this circle. If the point is contained on this circle,
			the value 0 is returned.
		\see distanceToDisc(), closestPointToEdge(), closestPointToDisc(). */
	float distanceToEdge(const CVec3D &point) const;
//	float distanceToEdge(const CRay &ray, float *d, CVec3D *closestPoint) const;
//	float distanceToEdge(const CLineSegment &lineSegment, float *d, CVec3D *closestPoint) const;
//	float distanceToEdge(const CLine &line, float *d, CVec3D *closestPoint) const;

	/// Computes the distance of the given object to this disc (filled circle).
	/** If the point is contained inside this disc, the value 0 is returned.
		\see distanceToEdge(), closestPointToEdge(), closestPointToDisc().
		\todo Implement distanceToDisc(CRay/CLineSegment/CLine). */
	float distanceToDisc(const CVec3D &point) const;
/*
	float distanceToDisc(const CRay &ray, float *d, CVec3D *closestPoint) const;
	float distanceToDisc(const CLineSegment &lineSegment, float *d, CVec3D *closestPoint) const;
	float distanceToDisc(const CLine &line, float *d, CVec3D *closestPoint) const;
*/
	/// Computes the closest point on the edge of this circle to the given point.
	/** \todo Implement closestPointToEdge(CRay/CLineSegment/CLine).
		\see distanceToEdge(), distanceToDisc(), closestPointToDisc(). */
	CVec3D closestPointToEdge(const CVec3D &point) const;
//	CVec3D closestPointToEdge(const CRay &ray, float *d) const;
//	CVec3D closestPointToEdge(const CLineSegment &lineSegment, float *d) const;
//	CVec3D closestPointToEdge(const CLine &line, float *d) const;

	/// Computes the closest point on the disc of this circle to the given object.
	/** \todo Implement closestPointToDisc(CRay/CLineSegment/CLine).
		\see distanceToEdge(), distanceToDisc(), closestPointToEdge(). */
	CVec3D closestPointToDisc(const CVec3D &point) const;

	/// Tests this circle for an intersection against the given plane.
	/** \note For CCircle-CPlane intersection, there is no need to differentiate between a hollow or a filled circle (disc).
		\return The number of intersection points found for this circle and the given plane.
		\see intersectsDisc(). */
	int intersects(const CPlane &plane, CVec3D *pt1, CVec3D *pt2) const;
	int intersects(const CPlane &plane) const;

	/// Tests this disc for an intersection against the given object.
	/** \see intersects(). */
	bool intersectsDisc(const CLine &line) const;
	bool intersectsDisc(const CLineSegment &lineSegment) const;
	bool intersectsDisc(const CRay &ray) const;
    /// Returns a human-readable representation of this circle. Most useful for debugging purposes.
	/** The returned string specifies the center position, normal direction and the radius of this circle. */
	std::string toString() const;

	std::vector<CVec3D> CCircle::intersectsFaces(const CAABBox &aabb) const;
	std::vector<CVec3D> CCircle::intersectsFaces(const COBBox &obb) const;
#ifdef MATH_QT_INTEROP
	operator QString() const { return toString(); }
	QString toString() const { return QString::fromStdString(toString()); }
#endif
};

CCircle operator *(const CMat3D &transform, const CCircle &circle);
CCircle operator *(const CMatJoint3x4 &transform, const CCircle &circle);
CCircle operator *(const CMat4D &transform, const CCircle &circle);
CCircle operator *(const CQuaternion &transform, const CCircle &circle);

#ifdef MATH_QT_INTEROP
Q_DECLARE_METATYPE(CCircle)
Q_DECLARE_METATYPE(CCircle*)
#endif

namespace _2D{
std::ostream &operator <<(std::ostream &o, const CCircle &circle);
}


} //end GEO
}  //end SMF

#endif // __SMF_CIRCLE_
