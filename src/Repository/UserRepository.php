<?php

namespace App\Repository;

use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\QueryBuilder;
use Symfony\Bridge\Doctrine\RegistryInterface;

/**
 * @method User|null find($id, $lockMode = null, $lockVersion = null)
 * @method User|null findOneBy(array $criteria, array $orderBy = null)
 * @method User[]    findAll()
 * @method User[]    findBy(array $criteria, array $orderBy = null, $limit =
 *         null, $offset = null)
 */
class UserRepository extends ServiceEntityRepository
{
    public function __construct(RegistryInterface $registry)
    {
        parent::__construct(
            $registry,
            User::class
        );
    }

    public function findAllWithMoreThan5Posts()
    {
        return $this->getFindAllWithMoreThan5PostsQuery()
            ->getQuery()
            ->getResult();
    }

    public function findAllWithMoreThan5PostsExceptUser(User $user)
    {
        return $this->getFindAllWithMoreThan5PostsQuery()
            ->andHaving('u != :user')
            ->setParameter('user', $user)
            ->getQuery()
            ->getResult();
    }

    private function getFindAllWithMoreThan5PostsQuery(): QueryBuilder
    {
        $qb = $this->createQueryBuilder('u');

        return $qb->select('u')
            ->innerJoin(
                'u.posts',
                'mp'
            )
            ->groupBy('u')
            ->having('count(mp) > 5');
    }
}
